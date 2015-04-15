/*
   Microsoft SQL Server Integration Services Script Task
   Write scripts using Microsoft Visual C# 2008.
   The ScriptMain is the entry point class of the script.
*/

using System;
using System.Data;
using Microsoft.SqlServer.Dts.Runtime;
using System.Windows.Forms;
using Microsoft.SqlServer.Dts.Tasks.ExecuteSQLTask;

namespace ST_3717a8da891c4dc49966d7fda8f2b9a6.csproj
{
    [System.AddIn.AddIn("ScriptMain", Version = "1.0", Publisher = "", Description = "")]
    public partial class ScriptMain : Microsoft.SqlServer.Dts.Tasks.ScriptTask.VSTARTScriptObjectModelBase
    {

        #region VSTA generated code
        enum ScriptResults
        {
            Success = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Success,
            Failure = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Failure
        };
        #endregion

        /*
		The execution engine calls this method when the task executes.
		To access the object model, use the Dts property. Connections, variables, events,
		and logging features are available as members of the Dts property as shown in the following examples.

		To reference a variable, call Dts.Variables["MyCaseSensitiveVariableName"].Value;
		To post a log entry, call Dts.Log("This is my log text", 999, null);
		To fire an event, call Dts.Events.FireInformation(99, "test", "hit the help message", "", 0, true);

		To use the connections collection use something like the following:
		ConnectionManager cm = Dts.Connections.Add("OLEDB");
		cm.ConnectionString = "Data Source=localhost;Initial Catalog=AdventureWorks;Provider=SQLNCLI10;Integrated Security=SSPI;Auto Translate=False;";

		Before returning from this method, set the value of Dts.TaskResult to indicate success or failure.
		
		To open Help, press F1.
	*/

        // Variables globales
        Package package;
        Microsoft.SqlServer.Dts.Runtime.Application app;
        byte[] emptyBytes;

        public void Main()
        {
            // Logs
            emptyBytes = new byte[0];

            // Variables
            String StrCheminPackages = @"Z:\Sql Server 2008R2\MsBI_Framework\2_SSIS";
            String StrNomPackage = "PackageTest.dtsx";
            String StrNomExport = "Clients_Top10";

            // Creation de l'application
            app = new Microsoft.SqlServer.Dts.Runtime.Application();

            package = InitPackage(StrCheminPackages, StrNomPackage);

            // Recuperation des variables du package
            //Variables packageVars = package.Variables;

            ConnectionManager ConMgrFMK_MSBI = AddConnectionManager("localhost", "FMK_MSBI");

            Sequence seq_Exports = AddSequence("Exports", "Container des exports");
            Sequence seq_ExportFichier = AddSequence(StrNomExport, "Container " + StrNomExport);

            TaskHost th_CreateTable = AddSQLTask("Create table", "Preparation des tables necessaires a l'export", ConMgrFMK_MSBI, "SELECT 1 AS Test");
            TaskHost th_AlimNoPartition = AddSQLTask("Alim No Partition", "Alimentation de la table no partition si c est la premiere execution", ConMgrFMK_MSBI, "SELECT 1 AS Alim");
            AddConstraint(th_CreateTable, th_AlimNoPartition, DTSExecResult.Success);

            TaskHost th_GetExportInfo = AddSQLExportTask("Get Export Infos", "Recuperation des infos", ConMgrFMK_MSBI, "SELECT 1 AS StrModeExport", "ObjInfoExport");
            AddConstraint(th_AlimNoPartition, th_GetExportInfo, DTSExecResult.Success);

            ForEachLoop fel_mode = AddForEachLoop("Pour chaque mode", "Parcours des modes");
            AddConstraint(th_GetExportInfo, fel_mode, DTSExecResult.Success);

            SavePackage(StrCheminPackages, StrNomPackage);

            Dts.TaskResult = (int)ScriptResults.Success;
        }

        public Package InitPackage(String StrCheminPackages, String StrNomPackage)
        {
            // Supression du fichier avant creation
            try
            {
                System.IO.File.Delete(StrCheminPackages + "\\" + StrNomPackage);
                Dts.Log("Ancien fichier " + StrNomPackage + " supprime", 0, emptyBytes);
            }
            catch (System.IO.IOException e)
            {
                Dts.Log("Aucun fichier " + StrNomPackage + " a supprimer", 0, emptyBytes);
            }

            // Creation du package
            Package package = new Package();
            Dts.Log("Package cree", 0, emptyBytes);

            // Chargement du package , Boolean Override
            //Package package = app.LoadPackage(StrCheminPackages+"\\"+StrNomPackage, null);

            return package;
        }

        public void SavePackage(String StrCheminPackages, String StrNomPackage)
        {
            app.SaveToXml(StrCheminPackages + "\\" + StrNomPackage, package, null);
        }

        public ConnectionManager AddConnectionManager(String StrDataSource, String StrDatabaseName)
        {
            // Creation de la connection
            ConnectionManager ConMgr = package.Connections.Add("OLEDB");
            ConMgr.ConnectionString = "Provider=SQLOLEDB.1;" +
            "Integrated Security=SSPI;Initial Catalog=" + StrDatabaseName + ";" +
            "Data Source=" + StrDataSource + ";";
            ConMgr.Name = StrDatabaseName;
            ConMgr.Description = "Connection OLE DB vers la base " + StrDatabaseName;
            Dts.Log("Connection " + StrDatabaseName + " cree", 0, emptyBytes);

            return ConMgr;
        }

        public TaskHost AddSQLTask(String name, String Description, ConnectionManager manager, String sql)
        {
            TaskHost sqltask = package.Executables.Add("STOCK:SQLTask") as TaskHost;
            sqltask.Name = name;
            sqltask.Properties["Connection"].SetValue(sqltask, manager.ID);
            sqltask.Properties["Description"].SetValue(sqltask, Description);
            sqltask.Properties["SqlStatementSource"].SetValue(sqltask, sql);
            Dts.Log("SQLTask " + name + " cree", 0, emptyBytes);
            return sqltask;
        }

        public TaskHost AddSQLExportTask(String name, String Description, ConnectionManager manager, String sql, String variableName)
        {
            TaskHost sqltask = package.Executables.Add("STOCK:SQLTask") as TaskHost;
            sqltask.Name = name;
            sqltask.Properties["Connection"].SetValue(sqltask, manager.ID);
            sqltask.Properties["Description"].SetValue(sqltask, Description);
            sqltask.Properties["SqlStatementSource"].SetValue(sqltask, sql);

            Variable varObj = package.Variables.Add(variableName, false, "User", new Object());
            Dts.Log("Variable " + variableName + " cree", 0, emptyBytes);

            ExecuteSQLTask tsk = sqltask.InnerObject as ExecuteSQLTask;
            tsk.ResultSetType = ResultSetType.ResultSetType_Rowset;
            tsk.ResultSetBindings.Add();
            IDTSResultBinding resultBinding = tsk.ResultSetBindings.GetBinding(0);
            resultBinding.ResultName = "0";
            resultBinding.DtsVariableName = "User::" + variableName;

            Dts.Log("SQLExportTask " + name + " cree", 0, emptyBytes);

            return sqltask;
        }

        public Sequence AddSequence(String name, String Description)
        {
            Sequence seq = (Sequence)package.Executables.Add("STOCK:SEQUENCE");
            seq.FailPackageOnFailure = true;
            seq.FailParentOnFailure = true;
            seq.Name = name;
            seq.Description = Description;
            Dts.Log("Ajout de la sequence "+name, 0, emptyBytes);

            Dts.Log("Sequence " + name + " cree", 0, emptyBytes);

            return seq;
        }

        public ForEachLoop AddForEachLoop(String name, String Description)
        {
            ForEachLoop fel = (ForEachLoop)package.Executables.Add("STOCK:FOREACHLOOP");
            fel.Name = name;
            fel.Description = Description;

            // Mapping des variables
            ForEachVariableMappings forEachVariableMappings = fel.VariableMappings;
            ForEachVariableMapping forEachVariableMapping = forEachVariableMappings.Add();

            // Creation du mapping
            forEachVariableMapping.VariableName = "StrModeExport";
            forEachVariableMapping.ValueIndex = 0;

            Dts.Log("ForEachLoop " + name + " cree", 0, emptyBytes);

            return fel;
        }

        public PrecedenceConstraint AddConstraint(Executable exec1, Executable exec2, DTSExecResult requiredstatus)
        {
            var constraint = package.PrecedenceConstraints.Add(exec1, exec2);
            constraint.Value = requiredstatus;

            Dts.Log("PrecedenceConstraint entre " + exec1.ToString() + " et " + exec2.ToString() + " cree", 0, emptyBytes);

            return constraint;
        }
    }
}