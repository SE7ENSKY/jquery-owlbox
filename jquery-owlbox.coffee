###
@name jquery-owlbox
@description Lightbox-like gallery for galleries, based on owlCarousel and Bootstrap 3 modals.
@version 1.0.0
@author Se7enSky studio <info@se7ensky.com>
@dependencies
 - [owlCarousel](http://owlgraphic.com/owlcarousel/)
 - [Bootstrap 3 modals](http://getbootstrap.com/javascript/#modals)
###
###! jquery-owlbox 1.0.0 http://github.com/Se7enSky/jquery-owlbox###

plugin = ($) ->
	
	"use strict"
	
	$.fn.owlbox = ->
		@each ->
			$(@).click (e) ->
				e.preventDefault()
				group = $(@).attr "rel"
				$items = if group then $("a[rel='#{group}'][href]") else $(@)
				currentIndex = $items.index(@)
				items = (for item in $items
					thumb: $(item).find("img").attr("src") or $(item).find("img").attr("data-src")
					big: $(item).attr("href")
				)
				popupHTML = """
					<div aria-hidden="true" role="dialog" class="gallery-popup modal fade" data-keyboard="true" tabindex="-1">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button aria-hidden="true" data-dismiss="modal" type="button" class="close"></button>
									<div class="counter small">Фотография <span>1</span> из <span>#{items.length}</span></div>
								</div>
								<div class="modal-body">
									<div class="owl_synced">
										<ul class="gallery owl owl_single carousel">
				"""
				popupHTML += """
											<li class="gallery-item item">
												<div class="gallery-item__link">
													<img data-src="#{item.big}" alt="" class="lazyOwl"/>
												</div>
											</li>
				""" for item in items
				popupHTML += """
										</ul>
										<ul class="gallery owl owl_thumbs carousel">
				"""
				popupHTML += """
											<li class="gallery-item item">
												<div class="gallery-item__link">
													<img data-src="#{item.thumb}" alt="" class="lazyOwl"/>
												</div>
											</li>
				""" for item in items
				popupHTML += """
										</ul>
									</div>
								</div>
							</div>
						</div>
					</div>
				"""
				$popup = $ popupHTML

				OWL_SYNCED_CLASS = "owl-item_current"

				sync1 = $popup.find(".owl:first")
				sync2 = $popup.find(".owl:last")

				center = (number) ->
					sync2visible = sync2.data("owlCarousel").visibleItems
					return unless sync2visible
					num = number
					found = false
					for i of sync2visible
						found = true  if num is sync2visible[i]
					if found is false
						if num > sync2visible[sync2visible.length - 1]
							sync2.trigger "owl.goTo", num - sync2visible.length + 2
						else
							num = 0  if num - 1 is -1
							sync2.trigger "owl.goTo", num
					else if num is sync2visible[sync2visible.length - 1]
						sync2.trigger "owl.goTo", sync2visible[1]
					else sync2.trigger "owl.goTo", num - 1  if num is sync2visible[0]
				
				sync1.owlCarousel
					singleItem: true
					slideSpeed: 394
					navigation: on
					pagination: off
					navigationText:	["",""]
					rewindNav: off
					lazyLoad: on
					afterAction: (el) ->
						current = @currentItem
						$popup.find(".counter span:first").text current + 1
						sync2.find(".owl-item").removeClass(OWL_SYNCED_CLASS).eq(current).addClass OWL_SYNCED_CLASS
						center current if sync2.data("owlCarousel")
					afterInit: (el) ->
						window.owl1 = @
						@jumpTo currentIndex

				sync2.owlCarousel
					navigation: on
					pagination: off
					navigationText:	["",""]
					rewindNav: off
					lazyLoad: on
					items: 7
					itemsDesktop: off
					itemsDesktopSmall: off
					itemsTablet: off
					itemsTabletSmall: off
					itemsMobile: off
					afterInit: (el) ->
						window.owl2 = @

				sync2.on "click", ".owl-item", (e) ->
					e.preventDefault()
					sync1.trigger "owl.goTo", $(@).data("owlItem")

				$("section.modals").append $popup
				$popup.modal "show"
				$popup.on "hidden.bs.modal", -> $popup.remove()

# UMD 
if typeof define is 'function' and define.amd then define(['jquery'], plugin) else plugin(jQuery)
