(function (doc, win) {
	"use strict"

	const initial_css = {
		position: 'absolute',
		float: 'left',
		borderRadius: '50%',
		width: '30px',
		height: '30px',
		backgroundColor: 'rgba(255, 69, 26, 0.75)',
		zIndex: 20,
		display: 'none'
	}
	let toggleBind = false
	const body = doc.getElementsByTagName('body')[0]
	let tail = doc.createElement('div')

	function initModule () {
		Object.assign(tail.style, initial_css)
		body.appendChild(tail)
		setKeyboards()
		if (window.Reveal.registerKeyboardShortcut) {
			Reveal.registerKeyboardShortcut('M', 'Toggle Mouse Pointer');
		}
	}
	
	function mouse_pointing(e) {
		tail.style.left = e.pageX - 15 + 'px'
		tail.style.top = e.pageY - 15 + 'px'
	}

	function toogleMousePointer () {
		if (!toggleBind) {
			tail.style.display = 'none'
			body.style.cursor = 'auto'
		} else {
			tail.style.display = 'block'
			body.style.cursor = 'none'
		}
	}

	function setKeyboards(params) {
		document.addEventListener('mousemove', mouse_pointing)
		document.addEventListener('keydown', function (event) {
                        // bind to 'm'
			if (event.keyCode === 77) {
				event.preventDefault()
				toggleBind = !toggleBind
				toogleMousePointer()
			}
		}, false )
	}
	
	
	initModule()
})(document, window)
