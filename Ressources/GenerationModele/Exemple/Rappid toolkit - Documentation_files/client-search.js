(function() {

    var searchStyle = document.createElement('style');
    document.body.appendChild(searchStyle);

    var searchables = document.querySelectorAll('.searchable > li > ul > li > a');
    for (var i = 0; i < searchables.length; i++) {
        var a = searchables[i];
        var li = a.parentNode;
	var topLi = li.parentNode.parentNode;
	var term = a.getAttribute('href').toLowerCase();
        li.setAttribute('data-index', term);
        topLi.setAttribute('data-index', topLi.getAttribute('data-index') + ' ' + term);
    }
    
    document.getElementById('api-search').addEventListener('input', function() {
        if (!this.value) {
            searchStyle.innerHTML = "";
            return;
        }
        searchStyle.innerHTML = ".searchable > li > ul > li:not([data-index*=\"" + this.value.toLowerCase() + "\"]) { display: none; }";
        searchStyle.innerHTML += ".searchable > li:not([data-index*=\"" + this.value.toLowerCase() + "\"]) { display: none; }";
    });

})()
