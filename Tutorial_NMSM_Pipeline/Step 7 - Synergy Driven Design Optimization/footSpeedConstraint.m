function [speedValue, constraintTerm] = footSpeedConstraint(values, ...
    modeledValues, auxdata, constraintTerm)
model = auxdata.model;
state = model.initSystem();
for i = 1:size(auxdata.coordinateNames, 2)
    model.getCoordinateSet().get(auxdata.coordinateNames{i}).setValue(state, values.positions(end, i), false);
    model.getCoordinateSet().get(auxdata.coordinateNames{i}).setSpeedValue(state, values.velocities(end, i));
end
model.realizeVelocity(state);
speedValue = model.getMarkerSet().get(constraintTerm.marker_name) ...
    .getVelocityInGround(state).get(0);
end