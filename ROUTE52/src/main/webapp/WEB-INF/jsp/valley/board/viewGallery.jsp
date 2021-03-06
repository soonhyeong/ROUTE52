<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../include/header.jsp" />
<jsp:include page="../include/subTop.jsp" />
<script type="text/javascript">

	$(document).ready(function() { 
		//initImage();
		
		initAttachFiles();	
		
		doSearchReply();
	});
	
	function initImage() {
		var imageName = "<c:out value='${upFileName1}'/>";
		var folderName = "<c:out value='${folderName}'/>";
		
		if(imageName != "") {
			$("#viewMainImage").attr("src", "<c:url value='/common/downloadImage.do?division=valley&folderName=" + folderName + "&fileName=" + imageName + "'/>");
		} else {
			$("#viewMainImage").attr("src", "<c:url value='/images/valley/boardDefaultImage.jpg'/>");
		}
	}
	
	function initAttachFiles() {
		var file1 = "<c:out value='${upOriginFile2}'/>";
		var file2 = "<c:out value='${upOriginFile3}'/>";
		var originFileName1 = "<c:out value='${upFileName2}'/>";
		var originFileName2 = "<c:out value='${upFileName3}'/>";
		var folderName = "<c:out value='${folderName}'/>";
	
		if(file2 != "") {
			$("#viewAttach").show();
		}
		
		if(file1 != "") {
			var extension = getExtensionOfFilename(file1);
			
			if(extension == "jpg" || extension == "jpeg" || extension == "png") {
				$("#viewMainImage").attr("src", "<c:url value='/common/downloadImage.do?division=valley&folderName=" + folderName + "&fileName=" + originFileName1 + "'/>");
			} else {
				$("#attachFile1 a").append(file1);
				$("#attachFile1 a").click(function() {
					downloadAttachFile(folderName, file1, originFileName1);
				});
			}
		}
		
		if(file2 != "") {
			$("#attachFile2 a").append(file2);
			$("#attachFile2 a").click(function() {
				downloadAttachFile(folderName, file2, originFileName2);
			});
		}
	}
	
	function downloadAttachFile(folderName, fileName, originFileName) {
		var sUrl = "<c:url value='/common/downloadFile.do'/>";
		var sParams = "";
		
		sParams += String.format("?fileName={0}", fileName);
		sParams += String.format("&originFileName={0}", originFileName);
		sParams += String.format("&folderName={0}", folderName);
		sParams += String.format("&division={0}", "valley");
	
		window.open(sUrl + sParams);
	}
	
	function doDelete() {
		var sUrl = "<c:url value='/valley/board/deleteBoard.do'/>";
		var sParams = "";
		
		var idx = "<c:out value='${idx}'/>";
		sParams += String.format("&idx={0}", idx);
		
		var deleteYn = confirm("?????? ?????????????????????????");
		
		if(deleteYn) {
			mAjax(sUrl, sParams, function(data) {
	        	if(data.resultCode == "0000") {
	         		alert("?????? ?????????????????????.");
	         	   
	         		location.href = "<c:url value='/valley/board/list.do?bbsType=${bbsType}'/>"
	            } else {
	         	   alert(data.resultMessage);
	            }
	        });	
		}
	}
	
	function doDeleteReply(reIdx) {
		var sUrl = "<c:url value='/valley/board/deleteReply.do'/>";
		var sParams = "";
		
		var idx = "<c:out value='${idx}'/>";
		sParams += String.format("&idx={0}", idx);
		sParams += String.format("&replyIdx={0}", reIdx);
		
		var deleteYn = confirm("????????? ?????????????????????????");
		
		if(deleteYn) {
			mAjax(sUrl, sParams, function(data) {
	        	if(data.resultCode == "0000") {
	        		doSearchReply();
	            } else {
	         	   alert(data.resultMessage);
	            }
	        });	
		}
	}
	
	function writeReply() {
		var msId = "<c:out value='${sessionScope.msMember.msId}'/>";		
		if(msId == "") {
			alert("????????? ??? ?????? ???????????????.");
			return;
		}
		
		var sUrl = "<c:url value='/valley/board/writeReply.do'/>";
		
		var reply = $("#txtReply").val();
		
		if(reply == null || reply == "") {
			alert("????????? ???????????????.");
			return;
		}
		
		var formData = new FormData($("#replyForm")[0]);
		
		progressStart();
		
		mPostAjax(sUrl, formData, function(data) {
     		progressStop();
     		
        	if(data.resultCode == "0000") {
        		$("#txtReply").val("");
        		
         		alert("?????? ???????????????.");
         		         		
         		doSearchReply();
            } else {
         	   alert(data.resultMessage);
            }
        });	
	}
	
	function doSearchReply() {
		var reBody = $("#commentContainer");
		
		var sUrl = "<c:url value='/valley/board/getBoardReplyData.do'/>";
		var sParams = "";
		
		sParams += String.format("idx={0}", "${idx}");
		
		progressStart();
		
		mAjax(sUrl, sParams, function(data) {
			if(data.resultCode == "0000") {
				reBody.empty();
				
				var rows = data.rows;
				
				$("#txtReplyCnt").html(rows.length);
				
				for(i=0; i<rows.length; i++) {
					var reply = "";
					reply += "<div class='replyBox'>                                                                                             ";
	         		reply += "    <img src='<c:url value='/images/valley/rp_arrow.png'/>' alt='' class='img'>									 ";
	         		reply += "    <div class='reply'>                                                        									 ";
	         		reply += "        <span class='new'><img src='<c:url value='/images/valley/rp_new.png'/>' alt='' style='display:{0}'></span> ";
	         		reply += "        <span class='name'>{1}</span>                                         									 ";
	        		reply += "        <span class='replyCont'>{2}</span>                                     									 ";
	         		reply += "        <span class='date'>{3}</span>                                           									 ";
	        		reply += "        <a href='javascript:doDeleteReply({4})' class='delete' style='display:{5};'>??????</a>    					 ";
	         		reply += "    </div>                                                                     									 ";
	         		reply += "</div>                                                                         									 ";
	         		
	         		var regDate = rows[i].REGDATE;
	         		var curDate = new Date().yyyymmdd();
	         		var name = rows[i].USERNAME;
	         		var content = rows[i].CONTENT;
	         		var replyIdx = rows[i].REPLY_IDX;
	         		var userNum = rows[i].USERNUM;
	         		var newDisplay = regDate == curDate ? "inline" : "none";
	         		var delDisplay = userNum == "${sessionScope.msMember.msNum}" ? "inline" : "none";
	         		regDate = regDate.substring(0, 4) + "/" + regDate.substring(4, 6) + "/" + regDate.substring(6, 8);
	         		
	         		reply = String.format(reply, newDisplay, name, content, regDate, replyIdx, delDisplay);
	         		
	         		reBody.append(reply);
				}
			} else {
				alert(data.resultMessage);	
			}
			
			progressStop();
		});
	}
</script>

<div class="lnbBox">
	<div class="lnb">
		<img src="<c:url value='/images/valley/ico-home.png'/>" alt="">
		<p>???????????? &nbsp;&nbsp;&nbsp; ??? <span>???????????????</span></p>
	</div>
</div>


<div id="wrap">
	<div class="contents">
		<div class="myzoneTabList4">
			<c:if test="${bbsType eq '1'}">
				<a href="<c:url value='/valley/board/list.do?bbsType=1'/>" class="on">????????????</a>
			</c:if>
			<c:if test="${bbsType ne '1'}">
				<a href="<c:url value='/valley/board/list.do?bbsType=1'/>">????????????</a>
			</c:if>
			<c:if test="${bbsType eq '2'}">
			<a href="<c:url value='/valley/board/list.do?bbsType=2'/>" class="on">??????</a>
			</c:if>
			<c:if test="${bbsType ne '2'}">
			<a href="<c:url value='/valley/board/list.do?bbsType=2'/>">??????</a>
			</c:if>
			<c:if test="${bbsType eq '3'}">		
			<a href="<c:url value='/valley/board/list.do?bbsType=3'/>" class="on">???????????????</a>
			</c:if>
			<c:if test="${bbsType ne '3'}">		
			<a href="<c:url value='/valley/board/list.do?bbsType=3'/>">???????????????</a>
			</c:if>				
			<a href="<c:url value='/valley/board/reference.do'/>">?????????</a>
		</div>
		<div class="subTitle subBottom">
			<span class="title">???????????????</span><!-- <span class="title">??????????????? / ??????????????????</span> -->
			<span class="titleDes"></span>
		</div>
		
		<div class="viewBox">
			<div class="viewTitleBox">
				<span class="viewTitle">${title}</span>
				<span class="viewDate">${regDate}</span>
			</div>		
			<img src="" id="viewMainImage" class="viewMainImage" alt="">
			<div class="viewTxt">
				${content}	
			</div>
			<div id="viewAttach" style="display: none">
				 <span>???????????? : </span>
				 <span id="attachFile1"><a></a></span>
				 <span id="attachFile2"><a></a></span>	 
			</div>
		</div>
		<div class="commentBox" id="reply-body">			
			<div class="commenTitle">
				<span class="commonDot">???????????????</span>
				<span class="comentTxt"> ???????????? ??? <span class="orangeRed" id="txtReplyCnt"></span>??? ????????? ????????????.</span>
			</div>
			<div class="commentTxt">
				<form id="replyForm" method="post">			
					<input type="hidden" name="idx" value="${idx}" />	
					<input type="text" name="reply" id="txtReply" /><a href="javascript:writeReply()" class="blueBtn">??????</a>	
				</form>			
			</div>
			<div class="comment" id="commentContainer">
				
			</div>
		</div>
		<div class="btnBox">
			<a href="<c:url value='/valley/board/list.do?bbsType=${bbsType}'/>" class="grayBtn">??????</a>
			<c:if test="${sessionScope.msMember.msNum == userNum}">
				<a href="<c:url value='/valley/board/modify.do?bbsType=${bbsType}&idx=${idx}'/>" class="blueBtn">??????</a>
				<a href="javascript:doDelete()" class="grayBtn">??????</a>
			</c:if>
		</div>
		
	</div><!-- contents End -->
</div>

<jsp:include page="../include/footer-quick.jsp" flush="true" />
<jsp:include page="../include/footer.jsp" flush="true" />