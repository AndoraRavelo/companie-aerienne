<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand d-flex align-items-center" href="/">
      <img src="/assets/img/airplane.jpg" alt="Logo" height="32" class="me-2">
      <span>Compagnie&nbsp;Aerienne</span>
    </a>

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar" aria-controls="mainNavbar" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="mainNavbar">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item"><a class="nav-link" href="/avions">Avions</a></li>
        <li class="nav-item"><a class="nav-link" href="/vols">Vols</a></li>
        <li class="nav-item"><a class="nav-link" href="/equipages">Equipages</a></li>
      </ul>
    </div>
  </div>
</nav>
