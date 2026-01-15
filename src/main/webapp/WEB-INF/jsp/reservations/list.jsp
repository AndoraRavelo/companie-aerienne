<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
  <div>
    <h1 class="h3 mb-1 d-flex align-items-center gap-2">
      <i class="bi bi-ticket-perforated"></i>
      <span>Réservations</span>
    </h1>
    <div class="text-muted">Filtre par trajet, date et heure pour afficher les réservations d'un vol programmé.</div>
  </div>

  <div class="d-flex gap-2">
    <a class="btn btn-outline-primary" href="/volsprogrammes">
      <i class="bi bi-calendar2-week me-1"></i>
      Vols programmés
    </a>
  </div>
</div>

<div class="card mb-3">
  <div class="card-body">
    <form class="row g-3 align-items-end" method="get" action="/reservations">
      <div class="col-12 col-md-5 col-lg-4">
        <label class="form-label text-muted">Trajet</label>
        <select name="route" class="form-select" onchange="this.form.submit()" required>
          <option value="">-- Trajet --</option>
          <c:forEach items="${routeOptions}" var="e">
            <option value="${e.key}" ${selectedRoute == e.key ? 'selected' : ''}>${e.value}</option>
          </c:forEach>
        </select>
      </div>
      <div class="col-12 col-md-4 col-lg-3">
        <label class="form-label text-muted">Date</label>
        <input type="date" name="date" class="form-control" value="${selectedDate}" onchange="this.form.submit()" required/>
      </div>
      <div class="col-12 col-md-3 col-lg-2">
        <label class="form-label text-muted">Heure</label>
        <select name="time" class="form-select" ${empty timeOptions ? 'disabled' : ''} required>
          <option value="">-- Heure --</option>
          <c:forEach items="${timeOptions}" var="t">
            <option value="${t}" ${selectedTime == t ? 'selected' : ''}>${t}</option>
          </c:forEach>
        </select>
      </div>
      <div class="col-12 col-lg-3 d-flex gap-2">
        <button type="submit" class="btn btn-primary">
          <i class="bi bi-funnel me-1"></i>
          Afficher
        </button>
        <a class="btn btn-outline-primary" href="/reservations">
          <i class="bi bi-x-circle me-1"></i>
          Réinitialiser
        </a>
      </div>
    </form>
  </div>
</div>

<c:if test="${selectedVp != null}">
  <div class="card mb-3">
    <div class="card-body">
      <div class="d-flex flex-wrap justify-content-between align-items-center gap-2">
        <div>
          <h5 class="mb-1 d-flex align-items-center gap-2">
            <i class="bi bi-airplane"></i>
            <span>${selectedVp.vol.aeroportDepart.nom} → ${selectedVp.vol.aeroportArrivee.nom}</span>
          </h5>
          <div class="text-muted"><i class="bi bi-clock me-1"></i>${selectedVp.dateHeure}</div>
        </div>
        <div>
          <a class="btn btn-sm btn-primary" href="/reservation/new?vpId=${selectedVp.id}">
            <i class="bi bi-plus-circle me-1"></i>
            Nouvelle réservation
          </a>
        </div>
      </div>

      <div class="d-flex flex-wrap gap-2 mt-3">
        <span class="badge text-bg-light border">
          <i class="bi bi-grid-3x3-gap me-1"></i>
          Total places : ${totalSeats}
        </span>
        <span class="badge text-bg-info">
          <i class="bi bi-receipt me-1"></i>
          Recette totale : <fmt:formatNumber value="${total}" type="currency" currencySymbol="Ar"/>
        </span>
        <span class="badge text-bg-warning">
          <i class="bi bi-graph-up-arrow me-1"></i>
          Max (avion plein) : <fmt:formatNumber value="${maxRevenue}" type="currency" currencySymbol="Ar"/>
        </span>
      </div>

      <c:if test="${not empty seatCounts}">
        <div class="mt-3">
          <div class="text-muted mb-1">Détail par classe</div>
          <div class="d-flex flex-wrap gap-2">
            <c:forEach items="${seatCounts}" var="e">
              <span class="badge text-bg-light border">
                ${e.key} : ${e.value}
                <c:if test="${not empty remainingSeatsByClass}">
                  | restants : ${remainingSeatsByClass[e.key]}
                </c:if>
              </span>
            </c:forEach>
          </div>
        </div>
      </c:if>
    </div>
  </div>

  <div class="card">
    <div class="card-body">
      <h5 class="card-title mb-3">Liste des réservations</h5>

      <table class="table table-hover align-middle mb-0">
    <thead class="table-light">
    <tr>
      <th>Client</th>
      <th>Nombre de places</th>
      <th>Détail</th>
      <th>Sous-total</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${reservations}" var="r">
      <tr>
        <td>${r.client.prenom} ${r.client.nom}</td>
        <td><span class="badge text-bg-primary">${r.nombrePlaces}</span></td>
        <td>
          <c:if test="${not empty details[r.id]}">
            <ul class="mb-0">
              <c:forEach items="${details[r.id]}" var="line">
                <li><c:out value="${line}"/></li>
              </c:forEach>
            </ul>
          </c:if>
        </td>
        <td>
          <c:if test="${not empty subtotals[r.id]}">
            <fmt:formatNumber value="${subtotals[r.id]}" type="currency" currencySymbol="Ar"/>
          </c:if>
        </td>
      </tr>
    </c:forEach>
    <c:if test="${empty reservations}">
      <tr><td colspan="4" class="text-center text-muted py-4"><i class="bi bi-info-circle me-1"></i>Aucune reservation pour ce vol.</td></tr>
    </c:if>
    </tbody>
      </table>
    </div>
  </div>
</c:if>
