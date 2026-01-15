<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-flex align-items-center gap-2 mb-4">
  <div class="rounded-circle bg-primary-subtle text-primary d-inline-flex align-items-center justify-content-center" style="width:44px;height:44px;">
    <i class="bi bi-ticket-perforated"></i>
  </div>
  <div>
    <h1 class="h3 mb-0">Réserver un vol</h1>
    <div class="text-muted">Choisis un client, une classe et le nombre de places.</div>
  </div>
</div>

<div class="card mb-4">
  <div class="card-body">
    <div class="d-flex flex-wrap justify-content-between align-items-start gap-2">
      <div>
        <h5 class="card-title mb-2 d-flex align-items-center gap-2">
          <i class="bi bi-airplane"></i>
          <span>Vol programmé</span>
        </h5>
        <div class="text-muted"><i class="bi bi-clock me-1"></i>${vp.dateHeure}</div>
        <div class="text-muted"><i class="bi bi-airplane-engines me-1"></i><c:out value="${vp.avion.matricule}"/></div>
      </div>

      <div class="d-flex flex-wrap gap-2">
        <span class="badge text-bg-success">
          <i class="bi bi-check-circle me-1"></i>
          Restants : ${restants}
        </span>
        <c:if test="${not empty totalSeats}">
          <span class="badge text-bg-light border">
            <i class="bi bi-grid-3x3-gap me-1"></i>
            Total : ${totalSeats}
          </span>
        </c:if>
      </div>
    </div>

    <c:if test="${not empty seatCounts}">
      <div class="mt-3">
        <div class="text-muted mb-1">Détail par classe</div>
        <div class="d-flex flex-wrap gap-2">
          <c:forEach items="${seatCounts}" var="e">
            <span class="badge text-bg-light border">${e.key} : ${e.value}</span>
          </c:forEach>
        </div>
      </div>
    </c:if>

    <div class="mt-3 d-flex flex-wrap gap-3">
      <div><span class="text-muted"><i class="bi bi-cash-coin me-1"></i>Tarif (par place) :</span> <span id="tarifDisplay">—</span></div>
      <div><span class="text-muted"><i class="bi bi-receipt me-1"></i>Total :</span> <span id="totalDisplay">—</span></div>
    </div>
  </div>
</div>

<div class="card mb-4">
  <div class="card-body">
    <h5 class="card-title mb-3">Informations réservation</h5>

    <form class="needs-validation" method="post" action="/reservation/create">
      <input type="hidden" name="vpId" value="${vp.id}"/>

      <div class="row g-3">
        <div class="col-12 col-md-6">
          <label class="form-label">Client</label>
          <select name="clientId" class="form-select" required>
            <c:forEach items="${passagers}" var="p">
              <option value="${p.id}">${p.prenom} ${p.nom}</option>
            </c:forEach>
          </select>
        </div>

        <div class="col-12 col-md-3">
          <label class="form-label">Classe</label>
          <select id="classeSelect" name="classeId" class="form-select" required>
            <c:forEach items="${classes}" var="c">
              <option value="${c.id}">${c.nom}</option>
            </c:forEach>
          </select>
        </div>

        <div class="col-12 col-md-3">
          <label class="form-label">Nombre de places</label>
          <input id="qteInput" type="number" name="nombrePlaces" class="form-control" min="1" max="${restants}" value="1" required>
          <div class="form-text">Maximum : ${restants}</div>
        </div>
      </div>

      <div class="d-flex flex-wrap gap-2 mt-4">
        <button type="submit" class="btn btn-primary">
          <i class="bi bi-check2-circle me-1"></i>
          Confirmer
        </button>
        <a href="/volsprogrammations" class="btn btn-outline-primary">
          <i class="bi bi-x-circle me-1"></i>
          Annuler
        </a>
      </div>
    </form>
  </div>
</div>

<script>
  (function() {
    // Build a tarifs map: classeId -> tarif
    var tarifs = {};
    <%-- expose tarifs from model --%>
    <c:forEach items="${tarifs}" var="t">
      tarifs['${t.classe.id}'] = '${t.tarif}';
    </c:forEach>

    var cls = document.getElementById('classeSelect');
    var qte = document.getElementById('qteInput');
    var tarifEl = document.getElementById('tarifDisplay');
    var totalEl = document.getElementById('totalDisplay');

    function fmt(amount) {
      try { return new Intl.NumberFormat('fr-FR').format(parseFloat(amount)); } catch(e) { return amount; }
    }

    function refresh() {
      var classeId = cls.value;
      var tarif = tarifs[classeId];
      var qty = parseInt(qte.value || '0', 10);
      if (tarif) {
        tarifEl.textContent = fmt(tarif) + ' Ar';
        totalEl.textContent = fmt(parseFloat(tarif) * qty) + ' Ar';
      } else {
        tarifEl.textContent = '—';
        totalEl.textContent = '—';
      }
    }

    cls.addEventListener('change', refresh);
    qte.addEventListener('input', refresh);
    // init
    refresh();
  })();
  </script>
