<%@page import="vo.OrderBean"%>
<%@page import="vo.DetailOrderBean"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<jsp:include page="/inc/header.jsp" />

<!-- QuickMenu -->
<jsp:include page="/quickMenu.jsp" />
<!-- breadcrumb -->

<%
	OrderBean mainorder = (OrderBean) request.getAttribute("mainorder");
ArrayList<DetailOrderBean> detailorderList = (ArrayList) request.getAttribute("detailorderList");
String mainorder_code = request.getParameter("code");
String member_id = mainorder.getMember_id();
%>
<div class="container">
	<div class="bread-crumb flex-w p-l-25 p-r-15 p-t-30 p-lr-0-lg">
		<a href="Main.go" class="stext-109 cl8 hov-cl1 trans-04"> Home <i
			class="fa fa-angle-right m-l-9 m-r-10" aria-hidden="true"></i>
		</a> <a href="MemberMypage.mo"
			class="stext-109 cl8 hov-cl1 trans-04"> My Page <i
			class="fa fa-angle-right m-l-9 m-r-10" aria-hidden="true"></i>
		</a> <a href="MyOrderList.or"
			class="stext-109 cl8 hov-cl1 trans-04"> My Order <i
			class="fa fa-angle-right m-l-9 m-r-10" aria-hidden="true"></i>
		</a> <span class="stext-109 cl4"> My Order Detail </span>
	</div>
</div>

<link type="text/css" rel="stylesheet" href="scss/common.css" />
<link type="text/css" rel="stylesheet" href="scss/mp_order.css" />
<link type="text/css" rel="stylesheet" href="scss/header.1.css" />
<link type="text/css" rel="stylesheet" href="scss/menu.2.css" />

<!-- 오더페이지 시작-->

<div id="contentWrapper">
	<div id="contentWrap">
		<div id="aside">
			<h2 class="aside-tit">주문 상세</h2>
			<div class="lnb-wrap">
				<div class="lnb-bx">
					<h2 class="txt txt1">SHOPPING INFO</h2>
					<div class="lnb">
						<ul>
							<li class="first"><a href="MyOrderList.or">주문내역</a></li>
							<!-- 							<li><a href="/shop/mypage.html?mypage_type=mycoupon">쿠폰내역</a></li> -->
							<!-- 							<li><a href="/shop/mypage.html?mypage_type=myreserve">적립금내역</a></li> -->

							<!-- 			이거 쓸건가..?				<li><a href="/shop/todaygoods.html">오늘본상품</a></li> -->

							<li><a href="#">상품 보관함</a></li>
							<li><a href="#">내 상품 리뷰</a></li>
							<li><a href="#">상품 QnA</a></li>
							<!-- <li class="attandance"><a href=""><strong>출석체크</strong></a></li>-->
						</ul>
					</div>
				</div>
				<div class="lnb-bx">
					<h2 class="txt txt2">COMMUNITY INFO</h2>
					<div class="lnb">
						<ul>
							<li class="first"><a href="#">내 게시글 보기</a></li>
							<li><a href="#">내 게시글 리뷰</a></li>
						</ul>
					</div>
				</div>
				<div class="lnb-bx">
					<h2 class="txt txt3">CUSTOMER INFO</h2>
					<div class="lnb">
						<ul>
							<li class="first"><a href="#">회원정보변경</a></li>
							<li><a href="#">회원탈퇴신청</a></li>
						</ul>
					</div>
				</div>
			</div>
			<!-- .lnb-wrap -->
		</div>
		<!-- #aside -->
		<hr>
		<div id="content">
			<div id="myOrder">
				<div class="tit-page-2">
					<h2>주문 상세</h2>
					<p class="dsc">
						주문일: <span class="fc-blue"><%=detailorderList.get(0).getDate()%> </span>
						 &nbsp;&nbsp;&nbsp; 주문번호: <span class="fc-blue"><%=mainorder_code%> </span>
					</p>
				</div>

				<!-- ---------------주문한 상품 나열-------------- -->
				<div class="page-body">

					<div class="table-d2-list">
						<table>
						<%
							for (int i = 0; i < detailorderList.size(); i++) {
							DetailOrderBean detailorder = detailorderList.get(i);
							String basicCode = detailorder.getOpt_productCode().substring(0, 4);
						%>
							<tr height="200px" onclick="location.href='ProductDetail.po?basicCode=<%=basicCode%>'">
								<td scope="row" width="300px"><div class="tb-center"><%=detailorder.getMain_img()%></div></td>
								<td scope="row"><div class="tb-center">
										<span><strong  style="font-size: 15px"><%=detailorder.getName()%></strong><br><br>
											<%=detailorder.getPrice()%> 원 / <%=detailorder.getCnt()%> 개
										</span>
									</div></td>
							</tr>
						<% } %>
						</table>
					</div><br>

					<!-- ---------------받는사람 정보-------------- -->
					<div class="tit-page-2"> <h2>받는 사람 정보</h2> </div>
					<div class="table-d2-list">
						<table>
							<tr>
								<td scope="row" width="300px"><div class="tb-center">받는 사람</div></td>
								<td scope="row"><strong><%=mainorder.getName() %></strong></td>
							</tr>
							<tr>
								<td scope="row" width="300px"><div class="tb-center">연락처</div></td>
								<td scope="row"><strong><%=mainorder.getPhone() %></strong></td>
							</tr>
							<tr>
								<td scope="row" width="300px"><div class="tb-center">받는 주소</div></td>
								<td scope="row"><strong><%=mainorder.getAddress() %></strong></td>
							</tr>
						</table>
					</div><br>
					
					<!-- ---------------받는사람 정보-------------- -->
					<div class="tit-page-2"> <h2>결제 정보</h2> </div>
					<div class="table-d2-list">
						<table>
							<tr>
								<td scope="row" width="300px"><div class="tb-center"><strong>결제 수단</strong></div></td>
								<td scope="row"><strong><%=mainorder.getPayment() %></strong></td>
							</tr>
							<tr>
								<td scope="row" width="300px"><div class="tb-center"><strong>총 결제 금액</strong></div></td>
								<td scope="row"><strong><%=mainorder.getTotal_price() %> 원</strong></td>
							</tr>
						</table>
						
					</div>

					<div style="height: 150px"></div>
					<div class="tb-center">
					<a href='MyOrderList.or'>
						<input type="button" value="주문목록으로 돌아기기" style="padding: 25px 50px; cursor: pointer;">
					</a>
					</div>
					<div style="height: 150px"></div>
					<!-- .page-body -->
				</div>
				<!-- #order -->
			</div>
			<!-- #content -->
		</div>
		<!-- #contentWrap -->
	</div>
</div>
<!-- 오더페이지 끝 -->


<jsp:include page="/inc/footer.jsp" />