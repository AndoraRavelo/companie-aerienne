<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid px-4 py-4">
  <!-- Header avec icône -->
  <div class="d-flex align-items-center mb-4">
    <i class="bi bi-ticket-perforated text-primary fs-2 me-3"></i>
    <div>
      <h1 class="mb-1 fw-bold text-dark">Réservations</h1>
      <p class="text-muted mb-0">
        <i class="bi bi-info-circle me-1"></i> 
        Consultation des réservations par vol
      </p>
    </div>
  </div>

  <!-- Filtre Vol programme -->
  <div class="card shadow-sm mb-4">
    <div class="card-body">
      <form method="get" action="/reservations" class="row g-3 align-items-end">
        <div class="col-md-8">
          <label class="form-label fw-medium text-secondary">
            <i class="bi bi-calendar-event me-1"></i> Sélectionner un vol
          </label>
          <div class="input-group">
            <span class="input-group-text bg-light">
              <i class="bi bi-airplane text-primary"></i>
            </span>
            <select name="vpId" class="form-select" required>
              <option value="">-- Choisir un vol --</option>
              <c:forEach items="${vols}" var="v">
                <option value="${v.id}" ${selectedVp != null && selectedVp.id == v.id ? 'selected' : ''}>
                  ${v.trajet.codeTrajet} | ${v.departTs}
                </option>
              </c:forEach>
            </select>
          </div>
        </div>
        <div class="col-md-4">
          <button type="submit" class="btn btn-primary w-100">
            <i class="bi bi-eye me-2"></i> Afficher les réservations
          </button>
        </div>
      </form>
    </div>
  </div>

  <c:if test="${selectedVp != null}">
    <!-- Détails du vol sélectionné -->
    <div class="card border-primary mb-4">
      <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
        <h5 class="mb-0">
          <i class="bi bi-airplane me-2"></i> Vol : ${selectedVp.trajet.codeTrajet}
        </h5>
        <div class="badge bg-light text-primary fs-6">
          <i class="bi bi-clock me-1"></i> ${selectedVp.departTs}
        </div>
      </div>
      <div class="card-body">
        <div class="row">
          <div class="col-md-4">
            <div class="d-flex align-items-center mb-3">
              <div class="bg-info bg-opacity-10 rounded-circle p-2 me-3">
                <i class="bi bi-airplane-takeoff text-info"></i>
              </div>
              <div>
                <small class="text-muted d-block">Départ</small>
                <div class="fw-medium">${selectedVp.departTs}</div>
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <div class="d-flex align-items-center mb-3">
              <div class="bg-success bg-opacity-10 rounded-circle p-2 me-3">
                <i class="bi bi-airplane-landing text-success"></i>
              </div>
              <div>
                <small class="text-muted d-block">Arrivée</small>
                <div class="fw-medium">${selectedVp.arriveeTs}</div>
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <div class="d-flex align-items-center mb-3">
              <div class="bg-warning bg-opacity-10 rounded-circle p-2 me-3">
                <i class="bi bi-cash-coin text-warning"></i>
              </div>
              <div>
                <small class="text-muted d-block">Prix unitaire</small>
                <div class="fw-medium">
                  <fmt:formatNumber value="${selectedVp.prixUnitaire}" type="currency" currencySymbol="Ar"/>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Tableau des réservations -->
    <div class="card shadow-sm mb-4">
      <div class="card-header bg-light d-flex justify-content-between align-items-center">
        <h5 class="mb-0">
          <i class="bi bi-list-check me-2"></i> Réservations
          <span class="badge bg-primary ms-2">${reservations.size()}</span>
        </h5>
        <small class="text-muted">
          <i class="bi bi-info-circle me-1"></i>
          Détails des passagers et montants
        </small>
      </div>
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
              <tr>
                <th class="ps-4">
                  <i class="bi bi-qr-code me-1"></i> Code
                </th>
                <th>
                  <i class="bi bi-person me-1"></i> Passager
                </th>
                <th class="text-center">
                  <i class="bi bi-person-seat me-1"></i> Sièges
                </th>
                <th class="text-center">
                  <i class="bi bi-tag me-1"></i> PU
                </th>
                <th class="text-center pe-4">
                  <i class="bi bi-cash-stack me-1"></i> Total
                </th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty reservations}">
                  <c:forEach items="${reservations}" var="r">
                    <tr>
                      <td class="ps-4">
                        <span class="badge bg-dark">${r.codeResa}</span>
                      </td>
                      <td>
                        <div class="d-flex align-items-center">
                          <div class="bg-primary bg-opacity-10 rounded-circle p-2 me-3">
                            <i class="bi bi-person text-primary"></i>
                          </div>
                          <div>
                            <div class="fw-semibold">${r.passager.prenom} ${r.passager.nom}</div>
                          </div>
                        </div>
                      </td>
                      <td class="text-center">
                        <span class="badge bg-secondary px-3 py-2">
                          <i class="bi bi-123 me-1"></i> ${r.sieges}
                        </span>
                      </td>
                      <td class="text-center">
                        <span class="badge bg-info px-3 py-2">
                          <fmt:formatNumber value="${r.prixUnitaire}" type="currency" currencySymbol="Ar"/>
                        </span>
                      </td>
                      <td class="text-center pe-4">
                        <span class="badge bg-success px-3 py-2">
                          <i class="bi bi-currency-euro me-1"></i> 
                          <fmt:formatNumber value="${r.prix}" type="currency" currencySymbol="Ar"/>
                        </span>
                      </td>
                    </tr>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="5" class="text-center py-5">
                      <div class="py-4">
                        <i class="bi bi-ticket text-muted display-5 mb-3"></i>
                        <h5 class="text-muted mb-2">Aucune réservation</h5>
                        <p class="text-muted mb-0">Aucune réservation n'a été faite pour ce vol.</p>
                      </div>
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Recette totale -->
    <div class="alert alert-success border-success border-2">
      <div class="d-flex justify-content-between align-items-center">
        <div>
          <h5 class="alert-heading mb-1">
            <i class="bi bi-calculator me-2"></i>Recette totale
          </h5>
          <p class="mb-0">Montant total généré par les réservations de ce vol</p>
        </div>
        <div class="text-end">
          <h2 class="fw-bold mb-0">
            <fmt:formatNumber value="${total}" type="currency" currencySymbol="Ar"/>
          </h2>
          <small class="text-muted">
            <i class="bi bi-info-circle me-1"></i>
            Total TTC
          </small>
        </div>
      </div>
    </div>
  </c:if>
</div>