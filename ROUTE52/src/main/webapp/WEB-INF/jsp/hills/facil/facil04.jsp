<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../include/header.jsp" />
<jsp:include page="../include/subTop.jsp" />

<!-- FlexSlider -->
<script src="<c:url value='/js/hills/jquery.flexslider.js'/>"></script>

<script type="text/javascript">
	$(document).ready(function() { 
	    var offset = $(".myzoneTabList7").offset();
	    $('html, body').animate({scrollTop : offset.top}, 400);
	});
</script>

<script type="text/javascript">

	
	$(document).ready(function() { 
		facilTab2("1");
	});

	function facilTab2(gubun) {
		if (gubun == "1") {
			$("#facil1").attr("style", 'display:block');
			$("#facil2").attr("style", 'display:none');
			$("#facil3").attr("style", 'display:none');

			$('#facil1 #carousel').flexslider({
				animation : "slide",
				controlNav : false,
				animationLoop : false,
				slideshow : false,
				itemWidth : 210,
				itemMargin : 5,
				asNavFor : '#facil1 #slider'
			});

			$('#facil1 #slider').flexslider({
				animation : "slide",
				controlNav : false,
				animationLoop : false,
				slideshow : false,
				sync : "#facil1 #carousel",
				start : function(slider) {
					$('body').removeClass('loading');
				}
			});
		} else if (gubun == "2") {
			$("#facil1").attr("style", 'display:none');
			$("#facil2").attr("style", 'display:block');
			$("#facil3").attr("style", 'display:none');

			$('#facil2 #carousel').flexslider({
				animation : "slide",
				controlNav : false,
				animationLoop : false,
				slideshow : false,
				itemWidth : 210,
				itemMargin : 5,
				asNavFor : '#facil2 #slider'
			});

			$('#facil2 #slider').flexslider({
				animation : "slide",
				controlNav : false,
				animationLoop : false,
				slideshow : false,
				sync : "#facil2 #carousel",
				start : function(slider) {
					$('body').removeClass('loading');
				}
			});
		} else if (gubun == "3") {
			$("#facil1").attr("style", 'display:none');
			$("#facil2").attr("style", 'display:none');
			$("#facil3").attr("style", 'display:block');

			$('#facil3 #carousel').flexslider({
				animation : "slide",
				controlNav : false,
				animationLoop : false,
				slideshow : false,
				itemWidth : 210,
				itemMargin : 5,
				asNavFor : '#facil3 #slider'
			});

			$('#facil3 #slider').flexslider({
				animation : "slide",
				controlNav : false,
				animationLoop : false,
				slideshow : false,
				sync : "#facil3 #carousel",
				start : function(slider) {
					$('body').removeClass('loading');
				}
			});
		}
	}
</script>


<div class="lnbBox">
		<div class="lnb">
			<img src="<c:url value='/images/hills/ico-home.png'/>" alt="">
			<p>???????????? &nbsp;&nbsp;&nbsp; ??? <span>?????????</span></p>
		</div>
	</div>

<div id="wrap">
	<div class="contents">
		<div class="myzoneTabList7">
			<a href="<c:url value='/hills/facil/facil01.do'/>" class="">????????????</a>
			<a href="<c:url value='/hills/facil/facil02.do'/>" class="">?????????</a>
			<a href="<c:url value='/hills/facil/facil03.do'/>" class="">??????????????????</a>
			<a href="<c:url value='/hills/facil/facil04.do'/>" class="on">?????????</a>
			<a href="<c:url value='/hills/facil/facil05.do'/>" class="">?????????</a>					
			<a href="<c:url value='/hills/facil/facil06.do'/>" class="">?????????</a>
			<a href="<c:url value='/hills/facil/facil07.do'/>" class="">?????????</a>
			<%-- <a href="<c:url value='/hills/facil/facil08.do'/>" class="">????????????</a> --%>
		</div>
		
		<div class="subTitle">
			<span class="title">?????????</span>
		</div>
		<div class="subLine"></div>

		<div class="facilBox" id="facil1">
			<div class="facilTab3">
				<ul>
					<li onclick="javascript:facilTab2(1);">???????????????</li>
					<li class="off1" onclick="javascript:facilTab2(2);">???????????????</li>
					<li class="off1" onclick="javascript:facilTab2(3);">???????????????</li>
				</ul>
			</div>
			<div class="facilGWarp">
				<div class="slider">
					<div id="slider" class="flexslider">
						<ul class="slides">
							<li>
							<img src="<c:url value='/images/hills/facil/04/01-1.jpg'/>" >
							</li>
							<li>
							<img src="<c:url value='/images/hills/facil/04/01-2.jpg'/>" >
							</li>
						</ul>
					</div>
					<div id="carousel" class="flexslider1">
						<ul class="slides">
							<li>
							<img src="<c:url value='/images/hills/facil/04/01-1.jpg'/>" >
							</li>
							<li>
							<img src="<c:url value='/images/hills/facil/04/01-2.jpg'/>" >
							</li>
						</ul>
					</div>
				</div>			
					
				<div class="facilInfo">
					<div class="icon">?????????</div>
					<ul>
						<li>						
						????????????????????? ?????? ???????????? ?????? ?????? ???????????? ????????? ????????? ????????? ????????? ????????? ??? ?????? ???????????????.
						</li>
					</ul>		
				</div>
			</div>
		</div>
		
		<div class="facilBox" id="facil2">
			<div class="facilTab3">
				<ul>
					<li class="off1" onclick="javascript:facilTab2(1);">???????????????</li>
					<li onclick="javascript:facilTab2(2);">???????????????</li>
					<li class="off1" onclick="javascript:facilTab2(3);">???????????????</li>
				</ul>
			</div>
			<div class="facilGWarp">
				<div class="slider">
					<div id="slider" class="flexslider">
						<ul class="slides">
							<li>
							<img src="<c:url value='/images/hills/facil/04/02-1.jpg'/>" >
							</li>
							<li>
							<img src="<c:url value='/images/hills/facil/04/02-2.jpg'/>" >
							</li>
							<li>
							<img src="<c:url value='/images/hills/facil/04/02-3.jpg'/>" >
							</li>
						</ul>
					</div>
					<div id="carousel" class="flexslider1">
						<ul class="slides">
							<li>
							<img src="<c:url value='/images/hills/facil/04/02-1.jpg'/>" >
							</li>
							<li>
							<img src="<c:url value='/images/hills/facil/04/02-2.jpg'/>" >
							</li>
							<li>
							<img src="<c:url value='/images/hills/facil/04/02-3.jpg'/>" >
							</li>
						</ul>
					</div>
				</div>			
			
				<div class="facilInfo">
					<div class="icon">?????????</div>
					<ul>
						<li>						
						????????? ??? ???????????? ????????? ????????? ????????? ????????? ??? ????????? ????????? ????????? ????????? ???????????? ???????????????.
						</li>
					</ul>		
				</div>
			</div>
		</div>
		
		<div class="facilBox" id="facil3">
			<div class="facilTab3">
				<ul>
					<li class="off1" onclick="javascript:facilTab2(1);">???????????????</li>
					<li class="off1" onclick="javascript:facilTab2(2);">???????????????</li>
					<li onclick="javascript:facilTab2(3);">???????????????</li>
				</ul>
			</div>
			<div class="facilGWarp">
				<div class="slider">
					<div id="slider" class="flexslider">
						<ul class="slides">
							<li>
							<img src="<c:url value='/images/hills/facil/04/03-1.jpg'/>" >
							</li>
							<li>
							<img src="<c:url value='/images/hills/facil/04/03-2.jpg'/>" >
							</li>
						</ul>
					</div>
					<div id="carousel" class="flexslider1">
						<ul class="slides">
							<li>
							<img src="<c:url value='/images/hills/facil/04/03-1.jpg'/>" >
							</li>
							<li>
							<img src="<c:url value='/images/hills/facil/04/03-2.jpg'/>" >
							</li>
						</ul>
					</div>
				</div>			
			
				<div class="facilInfo">
					<div class="icon">?????????</div>
					<ul>
						<li>						
						???????????? ????????? ????????? ????????? ????????? ????????? ?????? ???????????? ????????? ????????? ??? ?????? ???????????????.
						</li>
					</ul>		
				</div>
			</div>
		</div>
	</div>
	
	
	<!-- contents End -->
</div>

<jsp:include page="../include/footer-quick.jsp" flush="true" />
<jsp:include page="../include/footer.jsp" flush="true" />