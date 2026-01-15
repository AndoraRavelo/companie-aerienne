<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="d-flex align-items-center gap-2 mb-3">
  <div class="rounded-circle bg-success-subtle text-success d-inline-flex align-items-center justify-content-center" style="width:44px;height:44px;">
    <i class="bi bi-check2"></i>
  </div>
  <div>
    <h1 class="h3 mb-0">Réservation confirmée</h1>
    <div class="text-muted">Votre réservation a été enregistrée avec succès.</div>
  </div>
</div>

<div class="card mb-4">
  <div class="card-body">
    <h5 class="card-title mb-3">Récapitulatif</h5>

    <ul class="list-group list-group-flush">
      <li class="list-group-item d-flex justify-content-between align-items-center">
        <span class="text-muted"><i class="bi bi-clock me-2"></i>Date/heure</span>
        <span class="fw-semibold">${reservation.volProgrammation.dateHeure}</span>
      </li>
      <li class="list-group-item d-flex justify-content-between align-items-center">
        <span class="text-muted"><i class="bi bi-airplane me-2"></i>Avion</span>
        <span class="fw-semibold">${reservation.volProgrammation.avion.matricule}</span>
      </li>
      <li class="list-group-item d-flex justify-content-between align-items-center">
        <span class="text-muted"><i class="bi bi-person me-2"></i>Client</span>
        <span class="fw-semibold">${reservation.client.prenom} ${reservation.client.nom}</span>
      </li>
      <li class="list-group-item d-flex justify-content-between align-items-center">
        <span class="text-muted"><i class="bi bi-people me-2"></i>Nombre de places</span>
        <span class="badge text-bg-primary">${reservation.nombrePlaces}</span>
      </li>
      <li class="list-group-item d-flex justify-content-between align-items-center">
        <span class="text-muted"><i class="bi bi-cash-coin me-2"></i>Tarif unitaire</span>
        <span class="fw-semibold"><fmt:formatNumber value="${tarif}" type="currency" currencySymbol="Ar"/></span>
      </li>
      <li class="list-group-item d-flex justify-content-between align-items-center">
        <span class="text-muted"><i class="bi bi-receipt me-2"></i>Total</span>
        <span class="fw-bold"><fmt:formatNumber value="${total}" type="currency" currencySymbol="Ar"/></span>
      </li>
    </ul>
  </div>
</div>

<c:if test="${not empty places}">
  <div class="card mb-4">
    <div class="card-body">
      <h5 class="card-title mb-3">Places attribuées</h5>
      <div class="d-flex flex-wrap gap-2">
        <c:forEach items="${places}" var="rp">
          <span class="badge text-bg-light border">
            <i class="bi bi-grid-3x3-gap me-1"></i>
            ${rp.place}
          </span>
        </c:forEach>
      </div>
    </div>
  </div>
</c:if>

<div class="d-flex flex-wrap gap-2">
  <a href="/volsprogrammations" class="btn btn-primary">
    <i class="bi bi-arrow-left me-1"></i>
    Retour aux vols programmés
  </a>
  <a href="/reservations" class="btn btn-outline-primary">
    <i class="bi bi-ticket-perforated me-1"></i>
    Voir les réservations
  </a>
</div>
