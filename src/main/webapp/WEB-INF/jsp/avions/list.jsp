<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid px-4 py-4">
  <!-- Header avec icône -->
  <div class="d-flex justify-content-between align-items-center mb-4">
    <div class="d-flex align-items-center">
      <i class="bi bi-airplane-fill text-primary fs-2 me-3"></i>
      <div>
        <h1 class="mb-1 fw-bold text-dark">Flotte d'Avions</h1>
        <p class="text-muted mb-0">
          <i class="bi bi-info-circle me-1"></i> 
          Gestion de la flotte aérienne
        </p>
      </div>
    </div>
    <a href="/avions/new" class="btn btn-success">
      <i class="bi bi-plus-circle me-2"></i>Nouvel avion
    </a>
  </div>

  <!-- Filtres améliorés -->
  <div class="card shadow-sm mb-4">
    <div class="card-header bg-light">
      <h6 class="mb-0 fw-semibold">
        <i class="bi bi-funnel me-2"></i>Recherche et filtres
      </h6>
    </div>
    <div class="card-body">
      <form method="get" action="/avions" class="row g-3 align-items-end">
        <div class="col-md-4">
          <label class="form-label fw-medium text-secondary">
            <i class="bi bi-tag me-1"></i> Immatriculation
          </label>
          <div class="input-group">
            <span class="input-group-text bg-white">
              <i class="bi bi-search text-primary"></i>
            </span>
            <input type="text" class="form-control" name="immatriculation" 
                   placeholder="Ex: F-GABC" value="${param.immatriculation}">
          </div>
        </div>
        
        <div class="col-md-4">
          <label class="form-label fw-medium text-secondary">
            <i class="bi bi-clipboard-check me-1"></i> Statut
          </label>
          <select class="form-select" name="statut">
            <option value="">Tous les statuts</option>
            <option value="operationnel" ${param.statut == 'operationnel' ? 'selected' : ''}>
              <i class="bi bi-check-circle-fill text-success me-1"></i> Opérationnel
            </option>
            <option value="maintenance" ${param.statut == 'maintenance' ? 'selected' : ''}>
              <i class="bi bi-tools text-warning me-1"></i> Maintenance
            </option>
          </select>
        </div>
        
        <div class="col-md-4">
          <div class="d-flex gap-2">
            <button type="submit" class="btn btn-primary flex-grow-1">
              <i class="bi bi-filter me-2"></i> Appliquer filtres
            </button>
            <c:if test="${not empty param.immatriculation or not empty param.statut}">
              <a href="/avions" class="btn btn-outline-secondary">
                <i class="bi bi-x-lg"></i>
              </a>
            </c:if>
          </div>
        </div>
      </form>
    </div>
  </div>

  <!-- Tableau des avions -->
  <div class="card shadow-sm">
    <div class="card-header bg-light d-flex justify-content-between align-items-center">
      <h6 class="mb-0 fw-semibold">
        <i class="bi bi-table me-2"></i>Liste des avions
        <span class="badge bg-primary ms-2">${avions.size()} avions</span>
      </h6>
      <div class="text-muted small">
        <i class="bi bi-info-circle me-1"></i>
        Cliquez sur une ligne pour plus de détails
      </div>
    </div>
    
    <div class="card-body p-0">
      <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
          <thead class="table-primary">
            <tr>
              <th class="ps-4">
                <i class="bi bi-hash me-1"></i> ID
              </th>
              <th>
                <i class="bi bi-tag me-1"></i> Immatriculation
              </th>
              <th>
                <i class="bi bi-airplane me-1"></i> Modèle
              </th>
              <th class="text-center">
                <i class="bi bi-people me-1"></i> Capacité
              </th>
              <th class="text-center">
                <i class="bi bi-clipboard-check me-1"></i> Statut
              </th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${not empty avions}">
                <c:forEach items="${avions}" var="a">
                  <tr onclick="window.location.href='/avions/${a.id}'" style="cursor: pointer;">
                    <td class="ps-4">
                      <span class="badge bg-dark">#${a.id}</span>
                    </td>
                    <td>
                      <div class="d-flex align-items-center">
                        <div class="bg-primary bg-opacity-10 rounded-circle p-2 me-3">
                          <i class="bi bi-airplane text-primary"></i>
                        </div>
                        <div>
                          <div class="fw-bold">${a.immatriculation}</div>
                          <small class="text-muted">Immatriculation</small>
                        </div>
                      </div>
                    </td>
                    <td>
                      <div class="fw-semibold">${a.modele}</div>
                      <small class="text-muted">Modèle d'avion</small>
                    </td>
                    <td class="text-center">
                      <div class="d-flex flex-column align-items-center">
                        <span class="badge bg-secondary px-3 py-2 mb-1">
                          <i class="bi bi-person-fill me-1"></i> ${a.capacite}
                        </span>
                        <small class="text-muted">passagers</small>
                      </div>
                    </td>
                    <td class="text-center">
                      <c:choose>
                        <c:when test="${a.statut == 'operationnel'}">
                          <span class="badge bg-success px-3 py-2">
                            <i class="bi bi-check-circle me-1"></i> Opérationnel
                          </span>
                        </c:when>
                        <c:when test="${a.statut == 'maintenance'}">
                          <span class="badge bg-warning px-3 py-2">
                            <i class="bi bi-tools me-1"></i> Maintenance
                          </span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge bg-secondary px-3 py-2">${a.statut}</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="6" class="text-center py-5">
                    <div class="py-4">
                      <i class="bi bi-airplane-slash display-1 text-muted mb-4"></i>
                      <h4 class="text-muted mb-3">Aucun avion trouvé</h4>
                      <p class="text-muted mb-4">
                        Aucun avion ne correspond à votre recherche.
                        <c:if test="${not empty param.immatriculation or not empty param.statut}">
                          <br>Essayez de modifier vos critères de recherche.
                        </c:if>
                      </p>
                      <div class="d-flex justify-content-center gap-3">
                        <c:if test="${not empty param.immatriculation or not empty param.statut}">
                          <a href="/avions" class="btn btn-outline-primary">
                            <i class="bi bi-arrow-clockwise me-2"></i> Réinitialiser
                          </a>
                        </c:if>
                        <a href="/avions/new" class="btn btn-primary">
                          <i class="bi bi-plus-circle me-2"></i> Ajouter un avion
                        </a>
                      </div>
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

 
</div>

<style>
  /* Styles pour la table */
  .table th {
    font-weight: 600;
    font-size: 0.9rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: #495057;
  }
  
  .table td {
    padding-top: 1rem;
    padding-bottom: 1rem;
    vertical-align: middle;
  }
  
  .table tbody tr {
    transition: all 0.2s ease;
  }
  
  .table tbody tr:hover {
    background-color: rgba(13, 110, 253, 0.08);
    transform: translateY(-1px);
  }
  
  /* Styles pour les badges */
  .badge {
    font-weight: 500;
    font-size: 0.85rem;
  }
  
  /* Styles pour les boutons */
  .btn-group .btn {
    border-radius: 0.375rem !important;
    margin: 0 2px;
  }
  
  /* Card styles */
  .card {
    border-radius: 10px;
    border: 1px solid rgba(0,0,0,0.05);
  }
  
  /* Clic sur ligne */
  tr[onclick]:hover {
    cursor: pointer;
  }
  
  /* Responsive */
  @media (max-width: 768px) {
    .btn-group {
      display: flex;
      flex-direction: column;
      gap: 5px;
    }
    
    .btn-group .btn {
      width: 100%;
    }
    
    .table-responsive {
      border: 1px solid #dee2e6;
      border-radius: 8px;
    }
  }
</style>