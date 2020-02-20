<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<nav aria-label="Page navigation example">
	<ul class="pagination">
		<li class="page-item"><a class="page-link" href="#"
			aria-label="Previous" onclick="limit(${pg.prePage })"> <span
				aria-hidden="true">&laquo;</span>
		</a></li>
		<c:forEach items="${pg.navigatepageNums }" var="n" varStatus="i">
				<li class="page-item ${n==pg.pageNum?"active":"" }"><a class="page-link" href="#"
				onclick="limit(${n })">${n }</a></li>
		</c:forEach>
		<li class="page-item"><a class="page-link" href="#"
			aria-label="Next" onclick="limit(${pg.nextPage })"> <span
				aria-hidden="true">&raquo;</span>
		</a></li>
	</ul>
</nav>
