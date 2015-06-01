CREATE ENDPOINT message_endpoint
STATE = STARTED
AS HTTP (
    AUTHENTICATION = ( INTEGRATED ),
    PATH = '/sql/demo',
    PORTS = ( CLEAR )
)
FOR SOAP (
  WEBMETHOD 
    'http://tempuri.org/'.'hello_world' 
    (NAME = 'BotanicDW_MEC.Webservices.testMessage'),
    BATCHES = ENABLED,
    WSDL = DEFAULT
  ) 

GRANT CONNECT ON HTTP ENDPOINT::message_endpoint TO Botanic\mgesche