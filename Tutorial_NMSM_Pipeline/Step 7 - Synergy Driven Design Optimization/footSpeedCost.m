function cost = footSpeedCost(values, modeledValues, auxdata, costTerm)
model = auxdata.model;
state = model.initSystem();
for i = 1:size(auxdata.coordinateNames, 2)
    model.getCoordinateSet().get(auxdata.coordinateNames{i}).setValue(state, values.positions(end, i), false);
    model.getCoordinateSet().get(auxdata.coordinateNames{i}).setSpeedValue(state, values.velocities(end, i));
end
model.realizeVelocity(state);
newSpeed = model.getMarkerSet().get(costTerm.marker_name) ...
    .getVelocityInGround(state).get(0);
cost = 1*(costTerm.target_speed - newSpeed).^2;
end