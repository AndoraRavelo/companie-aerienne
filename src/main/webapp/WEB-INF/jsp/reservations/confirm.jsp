<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<h1 class="mb-4 text-success">Réservation confirmée !</h1>

<div class="alert alert-success">
  Votre code de réservation est <strong>${reservation.codeResa}</strong>.
</div>

<ul class="list-group mb-4">
  <li class="list-group-item"><strong>Vol :</strong> ${reservation.volProgramme.trajet.codeTrajet}</li>
  <li class="list-group-item"><strong>Date départ :</strong> ${reservation.volProgramme.departTs}</li>
  <li class="list-group-item"><strong>Passager :</strong> ${reservation.passager.prenom} ${reservation.passager.nom}</li>
  <li class="list-group-item"><strong>Nombre de sièges :</strong> ${reservation.sieges}</li>
  <li class="list-group-item"><strong>Prix total :</strong> <fmt:formatNumber value="${reservation.prix}" type="currency" currencySymbol="Ar"/></li>
</ul>

<a href="/volsprogrammes" class="btn btn-primary">Retour aux vols</a>
