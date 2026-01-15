<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
  <div>
    <h1 class="h3 mb-1 d-flex align-items-center gap-2">
      <i class="bi bi-calendar2-week"></i>
      <span>Vols programmés</span>
    </h1>
    <div class="text-muted">Choisis un vol programmé et réserve une place en quelques clics.</div>
  </div>

  <div class="d-flex gap-2">
    <a class="btn btn-outline-primary" href="/reservations">
      <i class="bi bi-ticket-perforated me-1"></i>
      Réservations
    </a>
  </div>
</div>

<table class="table table-hover table-bordered align-middle">
  <thead class="table-light">
  <tr>
    <th>ID</th>
    <th>Route</th>
    <th>Date/heure</th>
    <th>Avion</th>
    <th>Capacité</th>
    <th>Réservés</th>
    <th>Restants</th>
    <th></th>
  </tr>
  </thead>
  <tbody>
  <c:forEach items="${volsInfos}" var="info">
    <tr>
      <td>${info.vp.id}</td>
      <td>${info.vp.vol.aeroportDepart.nom} → ${info.vp.vol.aeroportArrivee.nom}</td>
      <td><span class="text-muted"><i class="bi bi-clock me-1"></i>${info.vp.dateHeure}</span></td>
      <td>${info.vp.avion.matricule}</td>
      <td><span class="badge text-bg-light">${info.capacite}</span></td>
      <td><span class="badge text-bg-secondary">${info.siegesReserves}</span></td>
      <td><span class="badge text-bg-success">${info.restants()}</span></td>
      <td>
        <c:choose>
          <c:when test="${info.restants() > 0}">
            <a class="btn btn-sm btn-primary" href="/reservation/new?vpId=${info.vp.id}">
              <i class="bi bi-plus-circle me-1"></i>
              Réserver
            </a>
          </c:when>
          <c:otherwise>
            <span class="badge bg-secondary"><i class="bi bi-slash-circle me-1"></i>Complet</span>
          </c:otherwise>
        </c:choose>
      </td>
    </tr>
  </c:forEach>
  <c:if test="${empty volsInfos}">
    <tr>
      <td colspan="8" class="text-center text-muted py-4">
        <i class="bi bi-info-circle me-1"></i>
        Aucune programmation disponible.
      </td>
    </tr>
  </c:if>
  </tbody>
</table>
