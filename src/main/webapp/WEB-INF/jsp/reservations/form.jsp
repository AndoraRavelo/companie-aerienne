<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid px-4 py-4">
  <!-- Header -->
  <div class="d-flex align-items-center mb-4">
    <i class="bi bi-ticket-perforated text-primary fs-2 me-3"></i>
    <h1 class="mb-0 fw-bold">Réserver un vol</h1>
  </div>

  <!-- Détails du vol -->
  <div class="card shadow-lg border-primary mb-4">
    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
      <h5 class="mb-0">
        <i class="bi bi-airplane me-2"></i>Vol ${vp.trajet.codeTrajet}
      </h5>
      <span class="badge bg-light text-primary fs-6">ID: #${vp.id}</span>
    </div>
    <div class="card-body">
      <div class="row align-items-center">
        <div class="col-md-8">
          <div class="row">
            <div class="col-md-6">
              <div class="d-flex align-items-center mb-3">
                <div class="bg-info bg-opacity-10 rounded-circle p-2 me-3">
                  <i class="bi bi-airplane-takeoff text-info fs-4"></i>
                </div>
                <div>
                  <small class="text-muted d-block">Départ</small>
                  <h5 class="mb-0 fw-bold">${vp.departTs}</h5>
                </div>
              </div>
            </div>
            
            <div class="col-md-6">
              <div class="d-flex align-items-center mb-3">
                <div class="bg-success bg-opacity-10 rounded-circle p-2 me-3">
                  <i class="bi bi-airplane-landing text-success fs-4"></i>
                </div>
                <div>
                  <small class="text-muted d-block">Arrivée</small>
                  <h5 class="mb-0 fw-bold">${vp.arriveeTs}</h5>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <div class="col-md-4">
          <div class="row">
            <div class="col-6">
              <div class="text-center p-3 bg-success bg-opacity-10 rounded-3">
                <i class="bi bi-people fs-1 text-success mb-2 d-block"></i>
                <small class="text-muted d-block">Sièges restants</small>
                <h4 class="mb-0 fw-bold text-success">${restants}</h4>
              </div>
            </div>
            
            <div class="col-6">
              <div class="text-center p-3 bg-warning bg-opacity-10 rounded-3">
                <i class="bi bi-currency-euro fs-1 text-warning mb-2 d-block"></i>
                <small class="text-muted d-block">Prix unitaire</small>
                <h4 class="mb-0 fw-bold text-warning">
                  <fmt:formatNumber value="${vp.prixUnitaire}" /> Ar
                </h4>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Formulaire de réservation -->
  <div class="card shadow-lg">
    <div class="card-header bg-dark text-white">
      <h5 class="mb-0">
        <i class="bi bi-pencil-square me-2"></i>Détails de la réservation
      </h5>
    </div>
    <div class="card-body">
      <form class="needs-validation" method="post" action="/reservation/create" novalidate>
        <input type="hidden" name="vpId" value="${vp.id}"/>
        
        <div class="row">
          <!-- Passager -->
          <div class="col-md-6 mb-4">
            <div class="card h-100 border-0 bg-light">
              <div class="card-body">
                <h6 class="card-title fw-semibold mb-3">
                  <i class="bi bi-person-circle me-2 text-primary"></i>Informations passager
                </h6>
                <div class="mb-3">
                  <label class="form-label fw-medium">
                    <i class="bi bi-person-badge me-1"></i> Sélection du passager
                  </label>
                  <select name="passagerId" class="form-select" required>
                    <option value="" disabled selected>Sélectionner un passager...</option>
                    <c:forEach items="${passagers}" var="p">
                      <option value="${p.id}">${p.prenom} ${p.nom}</option>
                    </c:forEach>
                  </select>
                  <div class="form-text mt-2">
                    <i class="bi bi-info-circle me-1"></i>
                    Choisissez un passager existant dans la base
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Sièges -->
          <div class="col-md-6 mb-4">
            <div class="card h-100 border-0 bg-light">
              <div class="card-body">
                <h6 class="card-title fw-semibold mb-3">
                  <i class="bi bi-person-seat me-2 text-primary"></i>Configuration des sièges
                </h6>
                <div class="mb-3">
                  <label class="form-label fw-medium">
                    <i class="bi bi-123 me-1"></i> Nombre de sièges
                  </label>
                  <div class="input-group">
                    <span class="input-group-text bg-white">
                      <i class="bi bi-person-plus text-primary"></i>
                    </span>
                    <input type="number" name="sieges" class="form-control" 
                           min="1" max="${restants}" value="1" required>
                    <span class="input-group-text bg-white">
                      <span class="text-muted">/ ${restants}</span>
                    </span>
                  </div>
                  <div class="form-text mt-2">
                    <i class="bi bi-info-circle me-1"></i>
                    Maximum ${restants} siège(s) disponible(s) pour ce vol
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Récapitulatif -->
        <div class="card border-primary mb-4">
          <div class="card-header bg-primary bg-opacity-10 border-primary">
            <h6 class="mb-0 fw-semibold">
              <i class="bi bi-receipt me-2"></i>Récapitulatif de la commande
            </h6>
          </div>
          <div class="card-body">
            <div class="row">
              <div class="col-md-8">
                <div class="d-flex align-items-center">
                  <i class="bi bi-calculator fs-3 text-primary me-3"></i>
                  <div>
                    <h5 class="mb-1 fw-bold">Total estimé</h5>
                    <p class="text-muted mb-0">Prix calculé en fonction du nombre de sièges</p>
                  </div>
                </div>
              </div>
              <div class="col-md-4 text-end">
                <h3 class="fw-bold text-primary">
                  <fmt:formatNumber value="${vp.prixUnitaire}" /> Ar
                </h3>
                <small class="text-muted">1 siège × <fmt:formatNumber value="${vp.prixUnitaire}" /> Ar</small>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Boutons -->
        <div class="d-flex justify-content-between pt-3 border-top">
          <a href="/volsprogrammes" class="btn btn-outline-secondary px-4">
            <i class="bi bi-x-circle me-2"></i> Annuler
          </a>
          <button type="submit" class="btn btn-success px-5">
            <i class="bi bi-check-lg me-2"></i> Confirmer la réservation
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Style CSS -->
<style>
  .card {
    border-radius: 10px;
    border: 1px solid #e0e0e0;
  }
  
  .card-header {
    border-radius: 10px 10px 0 0;
  }
  
  .btn {
    border-radius: 8px;
    font-weight: 500;
    padding: 0.75rem 1.5rem;
  }
  
  .btn-success {
    background: linear-gradient(135deg, #198754, #20c997);
    border: none;
  }
  
  .btn-outline-secondary:hover {
    background-color: #6c757d;
    color: white;
  }
  
  .form-control:focus, .form-select:focus {
    border-color: #0d6efd;
    box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
  }
  
  .input-group-text {
    background-color: #f8f9fa;
    border-color: #dee2e6;
  }
  
  .badge {
    font-size: 0.9rem;
    padding: 0.5rem 1rem;
  }
  
  .bg-opacity-10 {
    --bs-bg-opacity: 0.1;
  }
  
  .rounded-3 {
    border-radius: 1rem !important;
  }
</style>