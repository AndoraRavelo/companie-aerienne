<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<h1 class="mb-4 text-success">Réservation confirmée !</h1>

<div class="alert alert-success">
  Votre réservation a été enregistrée avec succès.
</div>

<ul class="list-group mb-4">
  <li class="list-group-item"><strong>Date/heure :</strong> ${reservation.volProgrammation.dateHeure}</li>
  <li class="list-group-item"><strong>Avion :</strong> ${reservation.volProgrammation.avion.matricule}</li>
  <li class="list-group-item"><strong>Client :</strong> ${reservation.client.prenom} ${reservation.client.nom}</li>
  <li class="list-group-item"><strong>Nombre de places :</strong> ${reservation.nombrePlaces}</li>
  <li class="list-group-item"><strong>Tarif unitaire :</strong> <fmt:formatNumber value="${tarif}" type="currency" currencySymbol="Ar"/></li>
  <li class="list-group-item"><strong>Total :</strong> <fmt:formatNumber value="${total}" type="currency" currencySymbol="Ar"/></li>
</ul>

<c:if test="${not empty places}">
  <h5>Places attribuées</h5>
  <ul class="list-group mb-4">
    <c:forEach items="${places}" var="rp">
      <li class="list-group-item">Place n° ${rp.place}</li>
    </c:forEach>
  </ul>
</c:if>

<a href="/volsprogrammations" class="btn btn-primary">Retour aux vols programmés</a>
