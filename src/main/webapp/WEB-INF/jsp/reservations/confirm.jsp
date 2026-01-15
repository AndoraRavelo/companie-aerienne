<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid px-4 py-5">
  <!-- Header avec icône -->
  <div class="text-center mb-5">
    <div class="display-1 text-success mb-3">
      <i class="bi bi-check-circle-fill"></i>
    </div>
    <h1 class="fw-bold text-success mb-3">Réservation confirmée !</h1>
    <p class="lead text-muted">
      Votre réservation a été enregistrée avec succès
    </p>
  </div>

  <!-- Code de réservation -->
  <div class="card border-success border-3 shadow-sm mb-5">
    <div class="card-header bg-success text-white">
      <h5 class="mb-0">
        <i class="bi bi-qr-code me-2"></i>Code de réservation
      </h5>
    </div>
    <div class="card-body text-center py-4">
      <div class="display-4 fw-bold text-success mb-3">${reservation.codeResa}</div>
      <p class="text-muted mb-0">
        <i class="bi bi-info-circle me-1"></i>
        Conservez ce code pour toute réclamation
      </p>
    </div>
  </div>

  <!-- Détails de la réservation -->
  <div class="card shadow-sm mb-5">
    <div class="card-header bg-light">
      <h5 class="mb-0">
        <i class="bi bi-receipt me-2"></i>Détails de votre réservation
      </h5>
    </div>
    <div class="card-body">
      <div class="row">
        <!-- Vol -->
        <div class="col-md-6 mb-4">
          <div class="card h-100 border-0 bg-primary bg-opacity-5">
            <div class="card-body">
              <div class="d-flex align-items-center mb-3">
                <div class="bg-primary text-white rounded-circle p-3 me-3">
                  <i class="bi bi-airplane fs-4"></i>
                </div>
                <div>
                  <h6 class="text-muted mb-1">Vol</h6>
                  <h4 class="fw-bold text-dark">${reservation.volProgramme.trajet.codeTrajet}</h4>
                </div>
              </div>
              <div class="row">
                <div class="col-6">
                  <small class="text-muted d-block">Départ</small>
                  <div class="fw-medium">${reservation.volProgramme.departTs}</div>
                </div>
                <div class="col-6">
                  <small class="text-muted d-block">Arrivée</small>
                  <div class="fw-medium">${reservation.volProgramme.arriveeTs}</div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Passager -->
        <div class="col-md-6 mb-4">
          <div class="card h-100 border-0 bg-success bg-opacity-5">
            <div class="card-body">
              <div class="d-flex align-items-center mb-3">
                <div class="bg-success text-white rounded-circle p-3 me-3">
                  <i class="bi bi-person fs-4"></i>
                </div>
                <div>
                  <h6 class="text-muted mb-1">Passager</h6>
                  <h4 class="fw-bold text-dark">${reservation.passager.prenom} ${reservation.passager.nom}</h4>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Informations financières -->
      <div class="row">
        <div class="col-md-6">
          <div class="card border-info">
            <div class="card-body">
              <div class="row align-items-center">
                <div class="col-8">
                  <h6 class="text-muted mb-2">
                    <i class="bi bi-person-seat me-1"></i> Sièges réservés
                  </h6>
                  <h2 class="fw-bold text-info">${reservation.sieges}</h2>
                </div>
                <div class="col-4 text-end">
                  <div class="bg-info bg-opacity-10 rounded-circle p-3 d-inline-block">
                    <i class="bi bi-123 text-info fs-3"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <div class="col-md-6">
          <div class="card border-warning">
            <div class="card-body">
              <div class="row align-items-center">
                <div class="col-8">
                  <h6 class="text-muted mb-2">
                    <i class="bi bi-cash-stack me-1"></i> Montant total
                  </h6>
                  <h2 class="fw-bold text-warning">
                    <fmt:formatNumber value="${reservation.prix}" type="currency" currencySymbol="Ar"/>
                  </h2>
                </div>
                <div class="col-4 text-end">
                  <div class="bg-warning bg-opacity-10 rounded-circle p-3 d-inline-block">
                    <i class="bi bi-currency-exchange text-warning fs-3"></i>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Actions -->
  <div class="text-center py-4">
    <div class="d-flex justify-content-center gap-3">
      <a href="/volsprogrammes" class="btn btn-primary btn-lg px-5">
        <i class="bi bi-airplane me-2"></i>Retour aux vols
      </a>
      <a href="/reservations" class="btn btn-outline-success btn-lg px-5">
        <i class="bi bi-list-check me-2"></i>Voir mes réservations
      </a>
    </div>
    <p class="text-muted mt-4">
      <i class="bi bi-info-circle me-1"></i>
      Un email de confirmation vous a été envoyé
    </p>
  </div>
</div>

<!-- Style supplémentaire -->
<style>
  .display-1 {
    animation: pulse 2s infinite;
  }
  
  @keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.05); }
    100% { transform: scale(1); }
  }
  
  .card {
    border-radius: 12px;
    transition: transform 0.3s ease;
  }
  
  .card:hover {
    transform: translateY(-5px);
  }
  
  .btn-lg {
    border-radius: 10px;
    font-weight: 500;
    padding: 0.75rem 2rem;
  }
  
  .bg-opacity-5 {
    --bs-bg-opacity: 0.05;
  }
  
  .bg-opacity-10 {
    --bs-bg-opacity: 0.1;
  }
</style>