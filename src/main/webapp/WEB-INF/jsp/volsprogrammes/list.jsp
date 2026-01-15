<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid p-4">
  <!-- Header -->
  <div class="d-flex align-items-center mb-4">
    <i class="bi bi-calendar-event text-primary fs-3 me-3"></i>
    <h1 class="mb-0 text-dark fw-bold">Vols Programmés</h1>
    <c:if test="${not empty volsInfos}">
      <span class="badge bg-primary ms-3 px-3 py-2">
        <i class="bi bi-airplane me-1"></i> ${volsInfos.size()} vols
      </span>
    </c:if>
  </div>

  <!-- Filtre -->
  <div class="card shadow-sm mb-4">
    <div class="card-body p-3">
      <form method="get" action="/volsprogrammes" class="row g-2 align-items-center">
        <div class="col-md-4">
          <div class="input-group">
            <span class="input-group-text bg-light">
              <i class="bi bi-funnel text-primary"></i>
            </span>
            <select name="trajetId" class="form-select">
              <option value="">Tous les trajets</option>
              <c:forEach items="${trajets}" var="t">
                <option value="${t.id}" ${param.trajetId == t.id ? 'selected' : ''}>
                  ${t.codeTrajet}
                </option>
              </c:forEach>
            </select>
          </div>
        </div>
        <div class="col-md-8 d-flex align-items-center">
          <button type="submit" class="btn btn-primary me-2">
            <i class="bi bi-filter me-1"></i> Filtrer
          </button>
          <c:if test="${not empty param.trajetId}">
            <a href="/volsprogrammes" class="btn btn-outline-secondary">
              <i class="bi bi-x-lg me-1"></i> Réinitialiser
            </a>
          </c:if>
        </div>
      </form>
    </div>
  </div>

  <!-- Tableau -->
  <div class="card shadow-sm">
    <div class="card-body p-0">
      <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
          <thead class="table-primary">
            <tr>
              <th class="ps-4">
                <i class="bi bi-hash me-1"></i> ID
              </th>
              <th>
                <i class="bi bi-geo-alt me-1"></i> Trajet
              </th>
              <th>
                <i class="bi bi-clock me-1"></i> Départ
              </th>
              <th>
                <i class="bi bi-clock-fill me-1"></i> Arrivée
              </th>
              <th class="text-center">
                <i class="bi bi-people me-1"></i> Capacité
              </th>
              <th class="text-center">
                <i class="bi bi-check-circle me-1"></i> Réservés
              </th>
              <th class="text-center">
                <i class="bi bi-dash-circle me-1"></i> Restants
              </th>
              <th class="text-center">
                <i class="bi bi-cash-coin me-1"></i> PU
              </th>
              <th class="text-center pe-4">
                <i class="bi bi-gear me-1"></i> Action
              </th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${volsInfos}" var="info">
              <tr>
                <td class="ps-4 fw-bold">#${info.volProgramme.id}</td>
                <td>
                  <span class="fw-semibold">${info.volProgramme.trajet.codeTrajet}</span>
                </td>
                <td>
                  <div class="text-dark">${info.volProgramme.departTs}</div>
                </td>
                <td>
                  <div class="text-dark">${info.volProgramme.arriveeTs}</div>
                </td>
                <td class="text-center">
                  <span class="badge bg-secondary px-3 py-2">
                    ${info.capacite}
                  </span>
                </td>
                <td class="text-center">
                  <span class="badge bg-warning text-dark px-3 py-2">
                    ${info.siegesReserves}
                  </span>
                </td>
                <td class="text-center">
                  <c:choose>
                    <c:when test="${info.siegesRestants() > 0}">
                      <span class="badge bg-success px-3 py-2">
                        ${info.siegesRestants()}
                      </span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge bg-danger px-3 py-2">
                        ${info.siegesRestants()}
                      </span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td class="text-center">
                  <span class="badge bg-primary px-3 py-2">
                    <i class="bi bi-currency-euro me-1"></i> 
                    ${info.volProgramme.prixUnitaire}
                  </span>
                </td>
                <td class="text-center pe-4">
                  <c:choose>
                    <c:when test="${info.siegesRestants() > 0}">
                      <a class="btn btn-sm btn-primary px-3" 
                         href="/reservation/new?vpId=${info.volProgramme.id}">
                        <i class="bi bi-cart-plus me-1"></i> Réserver
                      </a>
                    </c:when>
                    <c:otherwise>
                      <span class="badge bg-dark px-3 py-2">
                        <i class="bi bi-ban me-1"></i> Complet
                      </span>
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>