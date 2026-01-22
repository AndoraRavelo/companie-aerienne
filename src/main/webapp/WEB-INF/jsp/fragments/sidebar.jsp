<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="uri" value="${pageContext.request.requestURI}"/>

<div class="sidebar-header px-3 mb-2">
  <div class="sidebar-title text-uppercase">Navigation</div>
</div>

<ul class="nav nav-pills flex-column gap-1 px-2">
  <li class="nav-item">
    <a class="nav-link ${uri == '/' ? 'active' : ''}" href="/">
      <i class="bi bi-speedometer2"></i>
      <span>Tableau de bord</span>
    </a>
  </li>

  <li class="nav-item">
    <a class="nav-link ${uri.startsWith('/avions') ? 'active' : ''}" href="/avions">
      <i class="bi bi-airplane"></i>
      <span>Avions</span>
    </a>
  </li>
  <li class="nav-item">
    <a class="nav-link ${uri.startsWith('/vols') && !uri.startsWith('/volsprogrammes') && !uri.startsWith('/volsprogrammations') ? 'active' : ''}" href="/vols">
      <i class="bi bi-signpost-split"></i>
      <span>Vols</span>
    </a>
  </li>
  <li class="nav-item">
    <a class="nav-link ${uri.startsWith('/volsprogrammes') || uri.startsWith('/volsprogrammations') ? 'active' : ''}" href="/volsprogrammes">
      <i class="bi bi-calendar2-week"></i>
      <span>Vols programmés</span>
    </a>
  </li>

  <div class="sidebar-sep my-2"></div>

  <li class="nav-item">
    <a class="nav-link ${uri.startsWith('/reservations') || uri.startsWith('/reservation') ? 'active' : ''}" href="/reservations">
      <i class="bi bi-ticket-perforated"></i>
      <span>Réservations</span>
    </a>
  </li>
  <li class="nav-item">
    <a class="nav-link ${uri.startsWith('/clients') ? 'active' : ''}" href="/clients">
      <i class="bi bi-people"></i>
      <span>Clients</span>
    </a>
  </li>
  <li class="nav-item">
    <a class="nav-link ${uri.startsWith('/publicites') ? 'active' : ''}" href="/publicites/ca">
      <i class="bi bi-megaphone"></i>
      <span>Publicités</span>
    </a>
  </li>
  <!-- <li class="nav-item"><a class="nav-link" href="/tarifs">Tarifs</a></li> -->
</ul>
