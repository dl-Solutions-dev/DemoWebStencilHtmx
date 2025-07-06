document.body.addEventListener('htmx:afterRequest', function (evt) {
	  if (evt.detail.requestConfig.path.includes('/ApplyInsertQuote') || evt.detail.requestConfig.path.includes('/DeleteQuote') || evt.detail.requestConfig.path.includes('/ApplyQuote')) {		
		htmx.trigger('#TotalQuote', 'UpdateTotalQuote');
		document.getElementById('TotalQuote').classList.add('flash');
		setTimeout(() => {
		  document.getElementById('TotalQuote').classList.remove('flash');
		}, 600);
	  } else if (evt.detail.requestConfig.path.includes('/ApplyInsertOrder') || evt.detail.requestConfig.path.includes('/DeleteOrder') || evt.detail.requestConfig.path.includes('/ApplyOrder')) {		
		htmx.trigger('#TotalOrder', 'UpdateTotalOrder');
		document.getElementById('TotalOrder').classList.add('flash');
		setTimeout(() => {
		  document.getElementById('TotalOrder').classList.remove('flash');
		}, 600);
	  } 
	});