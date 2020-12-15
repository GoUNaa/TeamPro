<%@page import="vo.ProdQnaBean"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.HashMap"%>
<%@page import="vo.ProductOptionBean"%>
<%@page import="vo.PageInfo"%>
<%@page import="vo.ProdReviewBean"%>
<%@page import="vo.ProductBean"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String member_id= (String)session.getAttribute("member_id");
	ArrayList<ProdQnaBean> qnaList = (ArrayList<ProdQnaBean>)request.getAttribute("qnaList");
	PageInfo pageInfo = (PageInfo)request.getAttribute("pageInfo");
	int nowPage = pageInfo.getPage();
	int maxPage = pageInfo.getMaxPage();
	int startPage = pageInfo.getStartPage();
	int endPage = pageInfo.getEndPage();
	int listCount = pageInfo.getListCount();
	
%>
<jsp:include page="/inc/header.jsp" />
<!-- QuickMenu -->
<jsp:include page="/quickMenu.jsp" />
<!-- 별점 스크립트 -->
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link href="https://www.jqueryscript.net/css/jquerysctipttop.css"
	rel="stylesheet" type="text/css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootswatch/4.3.1/flatly/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://use.fontawesome.com/5ac93d4ca8.js"></script>
<script src="js/bootstrap4-rating-input.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<style type="text/css">
.rat {
	margin: 150px auto;
	font-size: 20px;
}

.mini_rat {
	margin: 150px auto;
	font-size: 15px;
}
</style>

<!-- TAB기능 스타일 -->
<style>
@import url(https://fonts.googleapis.com/css?family=Lato:400,700);

#powerReview .tabs {
	width: 100%;
	margin-bottom: 29px;
	border-bottom: 1px solid #d9d9d9;
}

#powerReview .tabs .tab {
	display: inline-block;
	margin-bottom: -1px;
	padding: 20px 15px 10px;
	cursor: pointer;
	letter-spacing: 0;
	border-bottom: 1px solid #d9d9d9;
	/*-moz-user-select: -moz-none;*/
	-ms-user-select: none;
	-webkit-user-select: none;
	user-select: none;
	transition: all 0.1s ease-in-out;
}

#powerReview .tabs .tab a {
	font-size: 11px;
	text-decoration: none;
	text-transform: uppercase;
	color: #d9d9d9;
	transition: all 0.1s ease-in-out;
}

#powerReview .tabs .tab.active a, body .container .tabs .tab:hover a {
	color: #263238;
}

#powerReview .tabs .tab.active {
	border-bottom: 1px solid #263238;
}

#powerReview .content .signup-cont {
	display: none;
}
</style>

<!-- 끝 -->


<link type="text/css" rel="stylesheet" href="scss/common.css" />
<link type="text/css" rel="stylesheet" href="scss/shopdetail.css" />
<link type="text/css" rel="stylesheet" href="scss/header.1.css" />
<link type="text/css" rel="stylesheet" href="scss/menu.1.css" />
<link type="text/css" rel="stylesheet"
	href="/scss/power_review_custom.4.css" />


<script type="text/javascript">
	// option으로 선택한 값 받아와서 임시 저장
	var mixopt = "";
	function submix(id, val) {
		if(val == "") {
			$('#'+id).focus();
		} else if(mixopt == "" && id == "opt1") {
			mixopt = val;
		} else if(mixopt!="" && id == "opt2") {
			mixopt += " / " + val;
			optcheck(mixopt);
			mixopt = "";
		} else {
			$('#'+id).focus();
		}
	}

	// 선택된 옵션체크
	function optcheck(mixopt) {
		var oldopt = $('ul#show-option li span.show-value').html();
		if(oldopt != mixopt) {
			showlist(mixopt); 
		} else {
			alert('이미 선택된 옵션입니다.');
			return false;
		}
	}
	
	
	// option 2개 다 선택됐으면 값 전달받고 화면에 출력
	// ul뒤에 li 형식으로 달아놓기
	// 선택된 옵션명: '.show-value', 수량 감소: '#optminus', 수량 증가: '#optplus'
	// 선택된 수량: '#optnum', 선택 옵션 삭제: '#optdel'
	function showlist(mixopt) {
		var resultcount = $('ul#show-option li').length+1+'';
		var optcol=document.createElement('li');
		var id = "optcol"+resultcount;
		optcol.id = id;

		$('ul#show-option').append(optcol);
		var html = "<span class='size-203 flex-c-m respon6 show-value' name='optname'>" + mixopt
			 + "</span><div class='size-204 flex-w flex-m respon6-next'>" + 
			 "<div class='wrap-num-product flex-w m-r-20 m-tb-10' id='itemcnt" + resultcount + "'>" +
			 "<span class='btn-num-product-down cl8 hov-btn3 trans-04 flex-c-m' id='optminus" + resultcount + "' onclick='cntMinus(this.id)'>" + 
			 "<i class='fs-16 zmdi zmdi-minus'></i></span>" + 
			 "<input class='mtext-104 cl3 txt-center num-product' type='number' id='optnum" + resultcount + "' name='num-product' value='1'>" + 
			 "<span class='btn-num-product-up cl8 hov-btn3 trans-04 flex-c-m' id='optplus" + resultcount + "' onclick='cntPlus(this.id)'>" + 
			 "<i class='fs-16 zmdi zmdi-plus'></i></span></div></div>" + 
			 "<div><span style='cursor: pointer' id='optdel" + resultcount + "' onclick='optDelete("+ id + ")'>" + 
			 "<img src='https://img.icons8.com/fluent-systems-regular/24/000000/cancel.png'/></span></div>";
		$('#'+id).append(html);

		calculatePrice();
	}

	
	// 선택된 옵션 수량에 따른 가격 계산후 출력, 가격: '.price', '#total'
	function calculatePrice() {
		var totalprice = 0;
		var itemprice = parseInt($('span#item-price').text().replace(/[^0-9]/g, ''));

		$('ul#show-option li').each(function() {
			var itcnt = parseInt($(this).find('input').val());

			totalprice += itemprice * itcnt;
		});
		
		var resultcount = $('ul#show-option li').length;
		if(resultcount < 1) {
			$('#total').css('display', 'none');
		} else {
			$('#total').css('display', 'block');
		}

		$('#total span').text(totalprice + '원');
	}

	
	
	// 상품개수증가
	function cntPlus(id) {
		var numid = id.replace("plus", "num")
		
		var cnt = Number($('#'+numid).val());
		
		cnt += 1;
		
		$('#'+numid).val(cnt);
		
		calculatePrice();
	}
	
	// 상품개수감소
	function cntMinus(id) {
		var numid = id.replace("minus", "num");
		// optminus1 에서 minus를 num으로 고쳐서 optnum1으로 고침, optnum1은 상품 갯수 id
		
		var cnt = Number($('#'+numid).val());
		// optnum1에 있는 value 값을 받아와서 cnt에 저장
		
		if(cnt > 1) {
			cnt -= 1;
			$('#'+numid).val(cnt);
		}
		// 갯수가 1보다 크면 감소 1과 같거나 작으면 아무것도 안함
		
		calculatePrice();
	}

	// 선택옵션삭제
	function optDelete(id) {
		$(id).remove();
		calculatePrice();
	}
	
	// 장바구니,,,,넣어야함,,,
// 	function(){
// 	if(rating == 0) {
// 		alert("별점을 입력하세요");
// 		$('#rating1').focus();
// 		return false;
// 		}
// 	}

	// 옵션 관련 스크립트 끝
</script>
<!-- productDetail 관련  -->
<%
	String basicCode = request.getParameter("basicCode"); 
    ArrayList<ProductBean> productDetailList =(ArrayList<ProductBean>)request.getAttribute("productDetailList");
    ArrayList<ProductOptionBean> productColorList =(ArrayList<ProductOptionBean>)request.getAttribute("productColorList");
    ArrayList<ProductOptionBean> productSizeList =(ArrayList<ProductOptionBean>)request.getAttribute("productSizeList");
	ArrayList<String> likeBaiscCodeList = (ArrayList<String>)request.getAttribute("likeBasicCodeList");
    

    String[] main = productDetailList.get(0).getMain_img().split("/");
    String[] sub = productDetailList.get(0).getSub_img().split("/");
    
    String likeCheck = member_id+"/"+productDetailList.get(0).getBasicCode();
    
    DecimalFormat priceFormat = new DecimalFormat("###,###");
%>
<!-- 끝 -->

<!-- breadcrumb -->
<!-- <div class="container"> -->
<!-- 	<div class="bread-crumb flex-w p-l-25 p-r-15 p-t-30 p-lr-0-lg"> -->
<!-- 		<a href="main.go" class="stext-109 cl8 hov-cl1 trans-04">HOME -->
<!-- 			<i class="fa fa-angle-right m-l-9 m-r-10" aria-hidden="true"></i> -->
<%-- 		</a> <a href="ProductShop.po?type=X&xcode=<%=productDetailList.get(0).getXcode()%>&ncode=<%=productDetailList.get(0).getNcode()%>" class="stext-109 cl8 hov-cl1 trans-04"> --%>
<%-- 			<%=productDetailList.get(0).getNcode() %><i class="fa fa-angle-right m-l-9 m-r-10" aria-hidden="true"></i> --%>
<!-- 		</a> <span class="stext-109 cl4"> Jacket </span> -->
<!-- 	</div> -->
<!-- </div> -->


<!-- Product Detail -->
<section class="sec-product-detail bg0 p-t-65 p-b-60">
	<div class="container">
		<div class="row">
			<div class="col-md-6 col-lg-7 p-b-30">
				<div class="p-l-25 p-r-30 p-lr-0-lg">
					<div class="wrap-slick3 flex-sb flex-w">
						<div class="wrap-slick3-dots"></div>
						<div class="wrap-slick3-arrows flex-sb-m flex-w"></div>

						<div class="slick3 gallery-lb">
						<%for(int i=0; i<main.length; i++){%>
							
							<div class="item-slick3"
								data-thumb="upload/productUploadImg/<%=main[i] %>">
								<div class="wrap-pic-w pos-relative">
									<img src="upload/productUploadImg/<%=main[i] %>" alt="IMG-PRODUCT">

									<a
										class="flex-c-m size-108 how-pos1 bor0 fs-16 cl10 bg0 hov-btn3 trans-04"
										href="product/uploadImg/<%=main[i] %>"> <i
										class="fa fa-expand"></i>
									</a>
								</div>
							</div>
						<%}%>

						</div>
					</div>
				</div>
			</div>

			<div class="col-md-6 col-lg-5 p-b-30">
				<div class="p-r-50 p-t-5 p-lr-0-lg">
				<!-- 상품코드 -->
				<input type="hidden" id="item-code" value="code,,">
				<!-- 상품명 -->
					<h4 class="mtext-105 cl2 js-name-detail p-b-14" id="item-name"><%=productDetailList.get(0).getName() %>
						</h4>
				<!-- 상품가격 -->
					<span class="mtext-106 cl2" id="item-price"><%=priceFormat.format(productDetailList.get(0).getPrice())%>원</span>

<!-- 					<p class="stext-102 cl3 p-t-23">Nulla eget sem vitae eros -->
<!-- 						pharetra viverra. Nam vitae luctus ligula. Mauris consequat ornare -->
<!-- 						feugiat.</p> -->

					<!-- 상품 옵션 -->
					<div class="p-t-33" id="select-opt">
						<div class="flex-w flex-r-m p-b-10">
							<div class="size-203 flex-c-m respon6">Size</div>

							<div class="size-204 respon6-next rs1-select2 bor8 bg0">
								<select class="js-select2" id="opt1" name="time"
									onchange="submix(this.id, this.value)">
									<option value="0" selected>Choose an option</option>
									<%for(int i=0; i<productSizeList.size(); i++){%>
										<option value="<%=productSizeList.get(i).getSize()%>"><%=productSizeList.get(i).getSize() %></option>
									<% }%>
								</select>
								<div class="dropDownSelect2"></div>
							</div>
						</div>

						<div class="flex-w flex-r-m p-b-10">
							<div class="size-203 flex-c-m respon6">Color</div>

							<div class="size-204 respon6-next rs1-select2 bor8 bg0">
								<select class="js-select2" id="opt2" name="time"
									onchange="submix(this.id, this.value)">
									<option value="0" selected>Choose an option</option>
									<%for(int i=0; i<productColorList.size(); i++){%>
										<option value="<%=productColorList.get(i).getColor()%>"><%=productColorList.get(i).getColor() %></option>
									<% }%>
								</select>
								<div class="dropDownSelect2"></div>
							</div>
						</div>


						<div class="flex-w flex-r-m p-b-10"
							style="text-align: right; width: 570px; padding: 10px 30px;">

							<%-- 선택한 옵션 블럭 --%>
							<ul id="show-option" style="width: 500px;">
								<%-- 한 옵션이 들어가는 li--%>
								<%-- 한 옵션이 들어가는 li 끝 --%>
							</ul>



							<div class="size-204 flex-w flex-m respon6-next">
								<div class="price" class="size-203 flex-c-m respon6 " id="total">
									<span></span>
								</div>
								<br>
								<input type="submit" value="Add to cart"
								class="flex-c-m stext-101 cl0 size-101 bg1 bor1 hov-btn1 p-lr-15 trans-04 js-addcart-detail">
							</div>
							
						</div>
					</div>

					<%-- 좋아요 + 각종 공유 / yj --%>
					<div class="flex-w flex-m p-l-100 p-t-40 respon7">
						<div class="flex-m bor9 p-r-10 m-r-11">
						<%if(member_id !=null){%>
							
							<button 
								class="btn-addwish-b2 dis-block pos-relative js-addwish-b2 <%if(likeBaiscCodeList.contains(productDetailList.get(0).getBasicCode())){%> js-addedwish-b2 <%}else{%>js-addedwish-b1<%}%>" value="<%=likeCheck%>">
								<img class="icon-heart1 dis-block trans-04"
								src="images/icons/icon-heart-01.png" alt="ICON"> 
								<img class="icon-heart2 dis-block trans-04 ab-t-l"
								src="images/icons/icon-heart-02.png" alt="ICON">
							</button>
						<% }else{%>
							<a href="#"
								class="not_member">
								<img class="icon-heart1 dis-block trans-04"
								src="images/icons/icon-heart-01.png" alt="ICON">
							</a>
						 <% } %>
						</div>

						<a href="#"
							class="fs-14 cl3 hov-cl1 trans-04 lh-10 p-lr-5 p-tb-2 m-r-8 tooltip100"
							data-tooltip="Facebook"> <i class="fa fa-facebook"></i>
						</a> <a href="#"
							class="fs-14 cl3 hov-cl1 trans-04 lh-10 p-lr-5 p-tb-2 m-r-8 tooltip100"
							data-tooltip="Twitter"> <i class="fa fa-twitter"></i>
						</a> <a href="#"
							class="fs-14 cl3 hov-cl1 trans-04 lh-10 p-lr-5 p-tb-2 m-r-8 tooltip100"
							data-tooltip="Google Plus"> <i class="fa fa-google-plus"></i>
						</a>
					</div>
				</div>
			</div>
		</div>

		<!-- 상세정보 시작 -->
		<div id="productDetail">
			<div class="cboth width1260">

				<div id="page01" class="cboth pdt100"></div>
				<!-- 중복되는 탭 메뉴 include 로 뺌 -BIN- -->
				<jsp:include page="../inc/detail_tabmenu.jsp" />
				<div class="prd-detail">
					<form name="allbasket" method="post" action="/shop/basket.html">

						<!-- //item-wrap -->
						<div class="related-allbasket none">
							<a href="javascript:send_multi('3', '', 'relation', 'YES')">ADD
								TO CART</a>
						</div>
					</form>

					<div id="videotalk_area"></div>
					<!-- [OPENEDITOR] -->
					<table width="750" align="center" border="0" cellspacing="0"
						cellpadding="0">
						<tbody>
							<tr>
								<td align="center">
								<%for(int i=0; i<sub.length; i++){%>
								<img src="upload/productUploadImg/<%=sub[i] %>" imgborder="0"><br> 
								<% }%>
								</td>
							</tr>
						</tbody>
					</table>

					&gt;
					<!-- 몰티비 플레이어 노출 위치 -->
					<div id="malltb_video_player"
						style="margin-top: 10px; margin-bottom: 10px; text-align: center; display: none;"></div>

				</div>

				<a name="reviewboard"></a>
				<div class="cboth pdt100"></div>
				<div id="page02" class="cboth pdt100"></div>
				<!-- 중복되는 탭 메뉴 include 로 뺌 -BIN- -->
				<jsp:include page="../inc/detail_tabmenu.jsp" />

				<!-- BIN -->
				<!-- ------------------------------상품리뷰---------------------------------------  -->
				<div id="powerReview">
					<div class="hd-t">
						<h2>POWER REVIEW</h2>
					</div>
					<div id="writePowerReview">
						<div class="PR15N01-write">
							<form name="prw_form" id="prw_form" method="post" autocomplete="off" enctype="multipart/form-data">
								<input type="hidden" name="basicCode" value="<%=basicCode%>">
								<p><strong>별점을 매겨주세요</strong></p>
								<!-- 별점 -->
								<div class="rat">
									<input type="number" name="starScore" id="rating1" class="rating text-warning" value="0" />
								</div>
								<!-- 별점 -->
								<textarea name="content" id="prw_content" placeholder="리뷰 내용을 입력해주세요" required></textarea>
								<div class="thumb-wrap"></div>
								<input type="file" name="prw_file" class="trick file-attach" id="prw_file"> 
								<input type="button" value="리뷰 등록" id="lnk-review" class="lnk-review" style="text-align: right; padding: 20px 50px; cursor: pointer;">
							</form>
						</div>
					</div>
					<br>
					<br>
					<br>
					<div class="PR15N01-info">
						<dl class="score">
							<dt>5.0</dt>
							<dd>56개 리뷰 평점</dd>
						</dl>
						<div class="chart">
							<ul>
								<li><span class="tit">5 Stars</span> <span class="bar">
										<span class="abs" style="width: 95%"></span>
								</span> <span class="num">(53)</span></li>
								<li><span class="tit">4 Stars</span> <span class="bar">
										<span class="abs" style="width: 5%"></span>
								</span> <span class="num">(3)</span></li>
								<li><span class="tit">3 Stars</span> <span class="bar">
										<span class="abs" style="width: 0%"></span>
								</span> <span class="num">(0)</span></li>
								<li><span class="tit">2 Stars</span> <span class="bar">
										<span class="abs" style="width: 0%"></span>
								</span> <span class="num">(0)</span></li>
								<li><span class="tit">1 Stars</span> <span class="bar">
										<span class="abs" style="width: 0%"></span>
								</span> <span class="num">(0)</span></li>
							</ul>
						</div>
						<div class="photo">
							<ul>
								<li><a
									href="javascript:power_review_view_show('995649','00000', 0, 'photo');"><span></span><img
										src="http://board.makeshop.co.kr/board/special328/nasign_board8/square::201021181313.jpeg"
										alt=""></a>
								</li>
							</ul>
						</div>
						<p class="like">
							<strong>100%</strong>의 구매자들이 이 상품을 좋아합니다. (56명 중 56명)
						</p>
					</div>
					<div class="tabs">
						<ul>
							<li class="tab signin active"><a href="#signin">포토리뷰(<span class="review_count"></span>)</a></li>
							<!-- 포토리뷰(db연동값삽입) -->
							<li class="tab signup"><a href="#signup">일반리뷰(<span class="review_count"></span>)</a></li>
							<!-- 일반리뷰(db연동값삽입) -->
						</ul>
					</div>
					<div id="review_list"></div>
					<!-- ------------------------------상품리뷰---------------------------------------  -->
					</div>
					<div id="updatePowerReview" class="MS_power_review_update"></div>
					<div id="layerReplyModify" style="display: none">
						<div class="layer-wrap">
							<a class="close-layer" href="#layerReplyModify">닫기</a>
							<form name="pruc" id="pruc_form"
								action="/shop/power_review_comment.action.html" method="post"
								autocomplete="off">
								<div class="wrt">
									<textarea name="update_comment"></textarea>
								</div>
							</form>
							<div class="ctr">
								<a class="modify"
									href="javascript:power_review_update_comment();">수정</a>
							</div>
						</div>
						<!-- .layer-wrap -->
					</div>
					<!-- #layerReplyModify -->
				</div>
				<!-- #powerReview-->
				<p style="clear: both"></p>

				<div class="cboth pdt100"></div>
				<div id="page03" class="cboth pdt100"></div>
				<!-- 중복되는 탭 메뉴 include 로 뺌 -BIN- -->
				<jsp:include page="../inc/detail_tabmenu.jsp" />
				
				<a name="brandqna_list"></a>
				<div class="tit-detail">

					<%--				<p class="more fe">--%>
					<%--					<a href="/board/board.html?code=nasign">+ MORE</a>--%>
					<%--				</p>--%>
				</div>
				<!-- qna 리스트 시작 -BIN- -->
				<div class="table-slide qna-list">
					<table summary="번호, 제목, 작성자, 작성일, 조회">
						<caption>QnA 리스트</caption>
						<colgroup>
							<col width="80">
							<col width="30">
							<col width="*">
							<col width="100">
							<col width="100">
							<col width="80">
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><div class="tb-center">NO</div></th>
								<th scope="col"></th>
								<th scope="col"><div class="tb-center">SUBJECT</div></th>
								<th scope="col"><div class="tb-center">NAME</div></th>
								<th scope="col"><div class="tb-center">DATE</div></th>
								<th scope="col"><div class="tb-center">HIT</div></th>
							</tr>
						</thead>
						<%-- 이곳에 있는 tr 반복해서 리스트 넣기 --%>
						<%for(int i=0; i<qnaList.size(); i++){ %>
						<tbody>
							<tr class="nbg">
								<td>
									<div class="tb-center">
										<span class="reviewnum"><%=qnaList.get(i).getQna_num() %></span>
									</div>
								</td>
								<td>
									<div class="tb-center"></div>
								</td>
								<td>
									<div class="tb-left reply_depth0">
										<span> <a href=""><%=qnaList.get(i).getQna_subject() %></a></span> 
										<span style="font-size: 8pt;">(1)</span>
									</div>
								</td>
								<td>
									<div class="tb-center">
									<%=qnaList.get(i).getUsername()%>
									</div>
								</td>
								<td>
									<div class="tb-center">
									<%=qnaList.get(i).getDate()%>
									</div>
								</td>
								<td>
									<div class="tb-center">
										<span id="qna_board_showhits1"><%=qnaList.get(i).getQna_readcount()%></span>
									</div>
								</td>
							</tr>
							<div class="qna_board_content"></div>
							<tr class="MS_qna_content_box cnt2" id="qna_board_block1">
								<td colspan="6">
									<div class="tb-left">
										<div style="padding-bottom: 15px; padding-left: 80px; padding-right: 15px; padding-top: 15px">
											주문했는데요 사은품키링이랑 가방이랑 한번에 배송오는거맞죠?선물해야되서 그러는데 배송 빠르게될까요ㅜㅜ?
										</div>
										<a href="ProdQnaModifyForm.po?basicCode=<%=basicCode%>&qna_num=<%=qnaList.get(i).getQna_num()%>">MODIFY</a>
										<a href="ProdQnaReplyForm.po?basicCode=<%=basicCode%>&qna_num=<%=qnaList.get(i).getQna_num()%>">REPLY</a>
									</div>
								</td>
							<tr>
							<tr class="MS_qna_content_box cnt2" id="qna_board_block1">
								<td colspan="6">
									<div class="tb-left">
										<div class="MS_cmt_list_box">
											<div class="comment_depth1">
												<table class="MS_cmt_list" border="0" cellspacing="0" cellpadding="0">
													<tbody>
														<tr>
															<td class="MS_cmt_detail">
															<span class="MS_cmt_hname MS_cmt_depth MS_cmt_depth01">ORYANY</span>
															<span class="MS_cmt_date">2019-12-17 16:32:08</span>
															<div class="MS_cmt_content MS_cmt_depth01">
																	안녕하세요 고객님<br> 
																	주문번호 : 20191217133131-94240461131<br>
																	키링, 와이드 스트랩, 가방 수령하실 수 있습니다<br> 
																	17일 주문하신 상품은 18일
																	출고 대기 상태가 되며 <br> 
																	출고 이후 1-3배송일이 소요될 수 있습니다<br>
																	감사합니다.
															</div>
															</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
								</td>
							</tr>
						</tbody>
						<%
							}
						%>
					</table>
					<!-- qna pagin -->
					<div class="list-btm">
						<div class="paging-wrap">
							<div class="paging">
								<%
									if (nowPage <= 1) {
								%>
									<input type="button" value="이전">&nbsp;
								<%}else {%>
									<input type="button" value="이전" onclick="location.href='ProductDetail.po?basicCode=<%=basicCode %>&page=<%=nowPage - 1 %>'">&nbsp;
								<%} %>
									<%for(int i = startPage; i <= endPage; i++) { 
										if(i == nowPage) { %>
											[<%=i %>]&nbsp;
										<%}else { %>
											<a href="ProductDetail.po?basicCode=<%=basicCode %>"  class="now">[<%=i %>]</a>&nbsp;
										<%} %>
								<%} %>
								<%if(nowPage >= maxPage) { %>
									<input type="button" value="다음">
								<%}else { %>
									<input type="button" value="다음" onclick="location.href='ProductDetail.po?basicCode=<%=basicCode %>&page=<%=nowPage + 1 %>'">
								<%}%>
							</div>
						</div>
						<div class="btm_write">
							<a href="ProdQnaWriteForm.po?basicCode=<%=basicCode%>">WRITE</a>
						</div>
					</div>
				</div>
				<!-- qna pagin -->
				<!-- qna 리스트 끝 -BIN- -->

				<div class="cboth pdt100"></div>
				<div id="page04" class="cboth pdt100"></div>
				<!-- 중복되는 탭 메뉴 include 로 뺌 -BIN- -->
				<jsp:include page="../inc/detail_tabmenu.jsp" />

				<div class="cboth pdt30"></div>

				<!-- s: 상품 일반정보(상품정보제공 고시) -->
				<div id="productWrap">
					<table>
						<colgroup>
							<col width="210">
							<col width="*">
						</colgroup>
						<tbody>
							<tr>
								<th><span>종류</span></th>
								<td><span>상세설명참조</span></td>
							</tr>
							<tr>
								<th><span>소재</span></th>
								<td><span>상세설명참조</span></td>
							</tr>
							<tr>
								<th><span>색상</span></th>
								<td><span>상세설명참조</span></td>
							</tr>
							<tr>
								<th><span>크기</span></th>
								<td><span>상세설명참조</span></td>
							</tr>
							<tr>
								<th><span>제조자</span></th>
								<td><span>상세설명참조</span></td>
							</tr>
							<tr>
								<th><span>제조국</span></th>
								<td><span>상세설명참조</span></td>
							</tr>
							<tr>
								<th><span>품질보증기준</span></th>
								<td><span>관련법 및 소비자 분쟁해결 규정에 따름</span></td>
							</tr>
							<tr>
								<th><span>A/S 책임자와 전화번호</span></th>
								<td><span>(주)내자인/02-6224-8900</span></td>
							</tr>
						</tbody>
					</table>
				</div>


				<!-- e: 상품 일반정보(상품정보제공 고시) -->

				<div class="cboth pdt100"></div>
				<div id="page05" class="cboth pdt100"></div>
				<!-- 중복되는 탭 메뉴 include 로 뺌 -BIN- -->
				<jsp:include page="../inc/detail_tabmenu.jsp" />


				<!-- 배송/반품안내 내용 삽입영역 -->
				<div class="deli_info_area">
					<div class="deli_title">1. 주문 및 배송</div>
					<div class="deli_txt01">
						- 평일 오전 9시 이전 주문건은 당일 출고 진행되며, 이후 주문건은 익일(평일 기준) 출고 됩니다.<br>
						- 당일 주문 건 중 물류에 재고가 없을 경우, 약 2~3일의 재고 수급 기간이 소요될 수 있으며,<br>
						&nbsp;&nbsp;부득이하게 재고 수급이 불가할 경우, 품절 안내를 드릴 수 있으니 구매 시 참고 부탁 드립니다.<br>
						- 사이즈 및 무게는 기준에 따라 약간의 오차가 있을 수 있으며, 모니터 사양에 따라 색상이 다르게 보일 수 있습니다.
					</div>

					<div class="deli_txt02">
						<div class="deli_title02">
							<span></span> 주문 전 오야니 프리미엄 가죽에 대한 정보를 확인해 주세요.
						</div>
						글로벌 토탈 패션 브랜드 오야니(ORYANY)는 명품 하우스에서 사용하는 최고급 소재를 고집하여 세계 최고의 검사,
						검증,<br> 테스트를 인증하는 SGS*의 인증처에서 엄격한 품질, 공정관리를 거쳐 제작되었습니다. 패셔너블한
						디자인으로 최상의 제품<br> 퀄리티를 선보이는 동시에 최고의 가치소비를 지향하며 합리적인 가격대를
						제시합니다.<br> 오야니의 가죽은 천연가죽으로, 미세한 핏줄자국, 주름, 반점 등이 보일 수 있습니다.
						천연가죽의 특성으로 인한 가죽의 상태와,<br> 제거가 가능한 실밥, 봉제선의 미세한 흔들림 등 핸드메이드
						공정 중 발생할 수 있는 현상들은 제품의 불량 사유에 해당하지<br> 않으니, 참고 부탁 드립니다.<br>
						* SGS는 국제표준(ISO)절차를 준수하는 세계 최고의 검사, 검증, 테스트 및 인증 회사입니다.
						<div class="deli_title02">
							<span></span> LAUNDRY &amp; FABRIC CARE
						</div>
						- 천연가죽은 사람 피부와 동일 하므로 사용시 표면에 흠집 또는 색이 벗겨질 수 있습니다. 이는 제품의 하자가 아닌
						사용에 의한<br> &nbsp;&nbsp;자연적인 현상입니다.<br> - 상품 보관시 직사광선이나
						온도, 또는 습기가 높은 곳을 피하십시오.<br> - 가죽 염료는 수성이므로 면,마, 린넨 등의 흰 천연
						섬유에 오염될 염려가 있으므로 습기,땀 등에 주의하셔야 합니다.<br> - 천연가죽(스웨이드) 제품은 물에
						젖었을 경우 물이 빠질 수 있습니다.<br> - 에나멜, 가죽 및 합성피혁은 다른 소재와 밀착시 색이 이염되는
						현상이 있사오니, 취급 또는 보관시 주의하십시오.<br> - 볼펜이나 신문, 잡지 등에 색이 이염될 수 있으니
						주의해주시기 바랍니다.<br> - 물에 젖었을 경우 직사광선이나 열로 직접 건조하면 변질될 수 있으니 통풍이
						잘 되는 그늘에서 건조하시기 바랍니다.<br> - 가죽전용 크림으로 주 1회 정도 손질하여 주시면 제품을 오래
						사용하실 수 있습니다.<br> &nbsp;&nbsp;(단, 소재가 세무 종류일 경우에는 가죽 전용솔 및 깨끗한
						고무 지우개만 사용 가능)<br> - 오염되었을 때는 가죽전용 크림으로 세척하시고 일반세척제나 벤졸은 절대
						사용하시면 안됩니다.
					</div>

					<div class="deli_title">2. 교환 및 반품</div>
					<div class="deli_txt01">
						- 교환/반품 신청은 구매하신 사이트를 통해 접수 가능합니다.<br> - 상품 수령 후 7일 이내 미사용
						제품에 한해 신청 가능하며, 반품 상품 입고 확인 후 약 2~3일의 검품기간을 거쳐 교환/반품 진행됩니다.<br>
						&nbsp;&nbsp;(무통장 입금 건의 경우, 검품 완료 후 약 4~5일 정도의 환불 기간이 소요될 수 있습니다.)<br>
						- 오야니 직영몰 회원분께는 교환/반품 신청시 회수 접수 진행을 해드리고 있으며, 1회에 한해 무료 교환/반품
						가능합니다.
					</div>

					<div class="deli_txt02">
						<div class="deli_title02">
							<span></span> 교환/반품 불가 사유
						</div>
						- 상품 TAG을 제거 또는 포장 등의 손상이 있을 경우<br> - 제품을 사용했거나 사용 흔적이 있을 경우
						/ 향수 또는 화장품 등 이물이 묻었을 경우<br> - 제품 구성품을 분실 또는 동봉하지 않은 경우<br>
						- 미세한 스크래치 또는 실밥, 이중 봉제 등 불량이 아닌 사유로 교환/반품 신청할 경우<br> - 포장 상태
						불량으로 인한 제품 훼손의 경우<br> - 구매 내역이 확인되지 않을 경우<br> - 교환/반품
						접수를 하지 않고 상품만 반송한 경우
					</div>

					<div class="deli_title">3. A/S 접수</div>
					<div class="deli_txt01">
						- 품질 보증 기준 : 구입일로부터 1년 (수선 내용에 따라 무상 또는 유상 수선 진행)<br> - 구매하시는
						고객님께는 개런티 카드가 발송되며, 개런티 카드를 지참하셔야 A/S가 가능합니다.<br> 1) 전국 오야니
						매장 방문 접수 (면세점 접수 불가)<br> 2) 택배 접수<br> - 고객정보, 구매정보, 수선
						요청 사항 기재 / 개런티 카드 (또는 구매내역서) 동봉<br> - 택배지 주소 : (04995) 서울시
						광진구 군자동 동일로 284, 4층 오야니 AS담당자 앞 (T.02-6224-8900)
					</div>

				</div>

			</div>

		</div>
		<!-- productDetail -->
		<!-- 상세정보 끝 -->

	</div>

	<div class="bg6 flex-c-m flex-w size-302 m-t-73 p-tb-15">
		<span class="stext-107 cl6 p-lr-25"> SKU: JAK-01 </span> 
<%-- 		<span class="stext-107 cl6 p-lr-25"> Categories: <%=productDetailList.get(0).getBasicCode() %>, Men </span> --%>
	</div>
</section>



<!-- 스크립트파일 -->
<script type="text/javascript">
	var _gaq = _gaq || [];
	_gaq.push(['_setAccount', 'UA-36251023-1']);
	_gaq.push(['_setDomainName', 'jqueryscript.net']);
	_gaq.push(['_trackPageview']);
	(function() {
		var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
		ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
		var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
	})();
// 	try {
// 		fetch(new Request("https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js", { method: 'HEAD', mode: 'no-cors' })).then(function(response) {
// 			return true;
// 		}).catch(function(e) {
// 			var carbonScript = document.createElement("script");
// 			carbonScript.src = "//cdn.carbonads.com/carbon.js?serve=CK7DKKQU&placement=wwwjqueryscriptnet";
// 			carbonScript.id = "_carbonads_js";
// 			document.getElementById("carbon-block").appendChild(carbonScript);
// 		});
// 	} catch (error) {
// 		console.log(error);
// 	}
	$('.tabs .tab').click(function(){
		if ($(this).hasClass('signin')) {
			$('.tabs .tab').removeClass('active');
			$(this).addClass('active');
			$('.cont').hide();
			$('.signin-cont').show();
		}
		if ($(this).hasClass('signup')) {
			$('.tabs .tab').removeClass('active');
			$(this).addClass('active');
			$('.cont').hide();
			$('.signup-cont').show();
		}
	});
	/* detail_tabmenu 클릭한 #page01에 스크롤 on */
	$('.detail_tabmenu ul li').click(function(){
		$('.detail_tabmenu ul li').removeClass('on');
		$(this).addClass('on');
	});
</script>
<script>
	<%-- id세션값 없으면 로그인으로 이동해야함 (textarea, submit 클릭시) / yj --%>
	// BIN 상품 리뷰 입력
 	$(function(){
		    $("#lnk-review").click(function(){
	 			if($("#prw_content").val().trim() === ""){
		    		alert("리뷰를 입력하세요.");
		    		$("#prw_content").val("").focus();
		    	}else{
		            var form = $('#prw_form')[0];
		            var data = new FormData(form);
		    		$.ajax({
		                type: "POST",
		    			enctype: 'multipart/form-data',
		    			url: "ProdReviewWrite.po",
		    			processData: false,
		                contentType: false,
		                data: data,
		                success: function () {
		                	alert("리뷰 등록 완료");
		                	$("#prw_content").val("");
		                	$("#prw_file").val("");
		                	$("#rating").val("")
		                	getReply();
		                },
		    			error: function(request,status,error){
		    		        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		    		       }
		    		})
		    	}
		    })
		    // BIN 리뷰 리스트 호출
		    function getReply(){
		    	var basicCode = "<%=basicCode%>";
		    	var reviewPage = "";
		    	var active = $('.active').text();
		    	$.ajax({
	    			url: "ProdReviewList.po", // 요청 url
	                type: "POST", // post 방식
	                data: {
	                	basicCode : basicCode,
	                	reviewPage : reviewPage,
	                	active : active
	                },
	                success: function (json) { 
	                	json = json.replace(/\n/gi,"\\r\\n");
	                	$("#replyList").text(""); 
	                	var obj = JSON.parse(json); 
	                	var replyList = obj.replyList; 
	                	var output = ""; 
	                	for (var i = 0; i < replyList.length; i++) {
	   	                 for (var j = 0; j < replyList[i].length; j++) {
	    	                    var reply = replyList[i][j];
	    	                    if(j==0){
	    	                    	if(reply.hasImg){
			    	                    output += "<div class='content'><div class='signin-cont cont'>";
	    	                    	}else{
		    							output += "<div class='content'><div class='signup-cont cont'>";
	    	                    	}
	    	                    }else if(j == 1){
	    	                    	output += "<ul class='PR15N01-review-wrap'><li id='power_review_block995509' class='power-review-list-box'><dl class='desc'>"
										+"<dt class='first' >작성자</dt><dd>"+reply.id+"</dd>";
	    	                    }else if(j == 2){
	    	                    	output += "<dt>작성일</dt><dd>"+reply.date+"</dd></dl>";
	    	                    }else if(j == 3){
	    	                    	output += "<div class='hd-box'><div class='star-icon'><span class='mini_rat'><input type='number' class='rating text-default' value='"
	    	                    	+ reply.starScore +"'data-readonly /></span><span class='survey'>아주만족</span></div></div>";
	    	                    }else if(j == 4){
	    	                    	output += "<div class='pr-options' style='display: none;'><dl><dt class='emp'>구매한 옵션</dt><dd class='emp'>컬러 : BLACK, 사이즈 : S</dd></dl></div>"
	    	                    		+"<div class='content'><p class='content_p'><a href='javascript:power_review_more('995509', '00000');' class='more-options' id='review_content'>"+reply.content+"</a>"
	    	                    		+"<a class='pr-close' href='javascript:power_review_more_close('995509');'>... <span>닫기</span></a></p><div class='ctr'></div></div>";
	    	                    }else if(j == 5){
	    	                    	output += "<div class='photo-list'><ul><li><a href='javascript:power_review_view_show('995509', '00000', '0', 'detail');''>"
	    	                    		+"<img src='upload/prodReviewUpload/"+reply.product_img +"'></a><div class='attach-preview'></div></li></ul></div>";
	    	                    	output += "<div class='reply'><span class='pr-txt'>이 리뷰가 도움이 되셨나요?</span><a class='yes' href='javascript:power_review_good('995509', 'N', 'shopdetail');''><span>0</span></a>"
	    	                    		+"<a class='no' href='javascript:power_review_bad('995509', 'N', 'shopdetail');''><span>0</span></a></div></li></ul>";
	    	                    }else if(j == 6){
	    	                    	output +="<a href='ProdReviewDelete.po?num="+reply.num+"&basicCode="+"<%=basicCode%>"+"'>삭제</a><br></div></div><br><br>";
	    	                    }
	    	                    <!-- .PR15N01-review-wrap -->
// 	    						<div class="paging">
// 	    							<a class="now" href="#none"><span>1</span></a> <a
// 	    								href="javascript:power_review_page('2');"><span>2</span></a> <a
// 	    								class="nnext" href="javascript:power_review_page('2');"><img
// 	    								src="/images/d3/modern_simple/btn/btn_h15_review_nnext.gif"
// 	    								alt=""></a>
// 	    						</div>
	    						<!-- .paging -->
	    	        		};
	                	};
	   	              	$("#review_list").html(output); 
	   	              	$(".review_count").html(i);
	                },
	            error: function(request,status,error){
    		        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
 		      	}
		    	})
		    }
		    getReply(); // 해당 페이지 실행 시 해당 함수 호출
		   
 	})
</script>
<script>
	function review_delete(num){
		 // 리뷰 삭제
	    if(!confirm("정말 삭제하시겠습니까?")){
	    	return;
	    }else{
	    		$.ajax({
	                type: "POST",
	    			url: "ProdReviewDelete.po",
	                data: {
	                	num:  $("#num").val()
	                },
	                success: function () {
	                	alert("리뷰 삭제 완료");
	                	getReply();
	                },
	    			error: function(request,status,error){
	    		        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	    		       }
	    		})
	  	  	}
	    }
</script>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<!-- 스크립트파일끝 -->

 <jsp:include page="/inc/footer.jsp" />