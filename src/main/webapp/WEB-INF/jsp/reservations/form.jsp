<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-flex align-items-center gap-2 mb-4">
  <div class="rounded-circle bg-primary-subtle text-primary d-inline-flex align-items-center justify-content-center" style="width:44px;height:44px;">
    <i class="bi bi-ticket-perforated"></i>
  </div>
  <div>
    <h1 class="h3 mb-0">Réserver un vol</h1>
    <div class="text-muted">Choisis un client et saisis le nombre de places (et enfants) par classe.</div>
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
      <div class="mt-3 seat-detail">
        <div class="seat-detail-title">Détail par classe</div>
        <div class="d-flex flex-wrap gap-2">
          <c:forEach items="${seatCounts}" var="e">
            <c:set var="rem" value="${remainingSeatsByClass[e.key]}"/>
            <span class="badge text-bg-light border seat-detail-badge">
              <span class="seat-detail-class">${e.key}</span>
              <span class="seat-detail-sep">:</span>
              <span class="seat-detail-capacity">${e.value}</span>
              <span class="seat-detail-sep">|</span>
              <span class="seat-detail-label">restants</span>
              <c:choose>
                <c:when test="${rem == 0}">
                  <span class="seat-detail-remaining seat-detail-remaining-full">${rem}</span>
                </c:when>
                <c:otherwise>
                  <span class="seat-detail-remaining seat-detail-remaining-ok">${rem}</span>
                </c:otherwise>
              </c:choose>
            </span>
          </c:forEach>
        </div>
      </div>
    </c:if>

    <div class="mt-3 d-flex flex-wrap gap-3">
      <div><span class="text-muted"><i class="bi bi-receipt me-1"></i>Total estimé (tarifs adultes) :</span> <span id="totalDisplay">—</span></div>
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
      </div>

      <div class="mt-4">
        <h6 class="mb-2">Places par classe</h6>
        <div class="table-responsive">
          <table class="table table-sm align-middle mb-0">
            <thead class="table-light">
              <tr>
                <th>Classe</th>
                <th style="width:180px;">Places</th>
                <th style="width:180px;">Enfants</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach items="${classes}" var="c">
                <tr>
                  <td>${c.nom}</td>
                  <td>
                    <input
                      class="form-control places-input"
                      type="number"
                      name="places_${c.id}"
                      min="0"
                      value="0"
                      data-classe-id="${c.id}"
                    />
                  </td>
                  <td>
                    <input
                      class="form-control enfants-input"
                      type="number"
                      name="enfants_${c.id}"
                      min="0"
                      value="0"
                      data-classe-id="${c.id}"
                    />
                    <div class="form-text">Enfants ≤ places</div>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
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
    // expose tarifs from model
    <c:forEach items="${tarifsAdultes}" var="t">
      tarifs['${t.classe.id}'] = '${t.tarif}';
    </c:forEach>
    var totalEl = document.getElementById('totalDisplay');

    var placeInputs = document.querySelectorAll('.places-input');
    var enfantInputs = document.querySelectorAll('.enfants-input');

    function fmt(amount) {
      try { return new Intl.NumberFormat('fr-FR').format(parseFloat(amount)); } catch(e) { return amount; }
    }

    function refresh() {
      var total = 0;

      // enforce enfants <= places, and compute adult-based estimate
      placeInputs.forEach(function(inp) {
        var classeId = inp.getAttribute('data-classe-id');
        var qty = parseInt(inp.value || '0', 10);
        if (isNaN(qty) || qty < 0) qty = 0;

        var enfantInp = document.querySelector('.enfants-input[data-classe-id="' + classeId + '"]');
        var enf = enfantInp ? parseInt(enfantInp.value || '0', 10) : 0;
        if (isNaN(enf) || enf < 0) enf = 0;
        if (enf > qty) {
          enf = qty;
          if (enfantInp) enfantInp.value = '' + enf;
        }

        var tarif = tarifs[classeId];
        if (tarif) {
          total += parseFloat(tarif) * qty;
        }
      });

      if (total > 0) {
        totalEl.textContent = fmt(total) + ' Ar';
      } else {
        totalEl.textContent = '—';
      }
    }

    placeInputs.forEach(function(inp) { inp.addEventListener('input', refresh); });
    enfantInputs.forEach(function(inp) { inp.addEventListener('input', refresh); });
    // init
    refresh();
  })();
  </script>
