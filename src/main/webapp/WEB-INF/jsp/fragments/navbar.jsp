<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="navbar navbar-expand-lg navbar-dark py-2 shadow" style="background-color: #000000;">
  <div class="container-fluid">
    <!-- Brand with icon and text -->
    <a class="navbar-brand d-flex align-items-center fw-bold" href="/">
      <div class="position-relative me-2">
        <img src="/assets/img/airplane.jpg" alt="Logo" height="40" width="40" class="rounded-circle border border-white border-2">
        <i class="bi bi-airplane-engines text-white position-absolute" style="top: 50%; left: 50%; transform: translate(-50%, -50%); font-size: 1.2rem;"></i>
      </div>
      <div class="d-flex flex-column">
        <span class="fs-5 text-white">Compagnie Aérienne</span>
        <small class="text-light opacity-75" style="font-size: 0.75rem; margin-top: -3px;">Voyagez avec confiance</small>
      </div>
    </a>

    <!-- Toggle button -->
    <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar" aria-controls="mainNavbar" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <!-- Navigation links with icons -->
    <div class="collapse navbar-collapse" id="mainNavbar">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item mx-1">
          <a class="nav-link d-flex align-items-center px-3 rounded text-white" href="/avions">
            <i class="bi bi-airplane me-2"></i>
            <span>Avions</span>
          </a>
        </li>
        <li class="nav-item mx-1">
          <a class="nav-link d-flex align-items-center px-3 rounded text-white" href="/equipages">
            <i class="bi bi-people me-2"></i>
            <span>Équipages</span>
          </a>
        </li>
        <li class="nav-item mx-1">
          <a class="nav-link d-flex align-items-center px-3 rounded text-white" href="/volsprogrammes">
            <i class="bi bi-calendar-event me-2"></i>
            <span>Vols programmés</span>
          </a>
        </li>
        <li class="nav-item mx-1">
          <a class="nav-link d-flex align-items-center px-3 rounded text-white" href="/reservations">
            <i class="bi bi-ticket-perforated me-2"></i>
            <span>Réservations</span>
          </a>
        </li>
      </ul>
      
      <!-- Optional: User menu or additional icons -->
      <div class="d-flex align-items-center">
        <a href="#" class="text-white me-3" title="Rechercher">
          <i class="bi bi-search fs-5"></i>
        </a>
        <div class="vr bg-white opacity-50 me-3" style="height: 24px;"></div>
        <a href="#" class="text-white" title="Mon compte">
          <i class="bi bi-person-circle fs-4"></i>
        </a>
      </div>
    </div>
  </div>
</nav>

<!-- Optional: Add hover animation styles -->
<style>
  .navbar {
    background: linear-gradient(to right, #000000, #1a1a1a);
    border-bottom: 2px solid #ff0000;
  }
  
  .nav-link {
    transition: all 0.3s ease;
    color: #ffffff !important;
  }
  
  .nav-link:hover {
    background-color: rgba(255, 0, 0, 0.2) !important;
    transform: translateY(-1px);
    color: #ffcccc !important;
  }
  
  .nav-link.active {
    background-color: rgba(255, 0, 0, 0.3) !important;
    color: #ffffff !important;
  }
  
  .navbar-brand:hover {
    opacity: 0.9;
  }
  
  .navbar-toggler-icon {
    background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%28255, 255, 255, 0.8%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
  }
</style>