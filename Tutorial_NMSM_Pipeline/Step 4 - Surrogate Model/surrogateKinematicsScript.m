% Model (.osim) file used in Treatment Optimization
modelFileName = fullfile("..", "Step 1 - JMP", "KickingModel_JMP.osim");

% Reference kinematics file for coordinate sampling
referenceKinematicsFile = fullfile("..", "preprocessed", "IKData", "drive_kick_1.sto");

% Output directory name
surrogateDataDirectoryName = fullfile("surrogateData");

% Number of LHS points per time point
settings.samplePoints = 25;

% Default padding (radians) for rotational coordinate sampling
settings.angularPadding = deg2rad(20);

% Default padding (meters) for translational coordinate sampling
settings.linearPadding = 0;

% Padding ranges specific to coordinates. The deepest struct field name
% must exactly match a coordinate name in the reference kinematics file.
% Coordinates without a specified range will use positive and negative
% default padding for their ranges. 
% 
% Example: settings.padding.hip_flexion_r = [-0.1, 0.2];
settings.padding = struct();


% End of user-defined settings

model = Model(modelFileName);
[coordinateNames, ~, referenceKinematics] = parseMotToComponents( ...
    model, org.opensim.modeling.Storage(referenceKinematicsFile));
referenceKinematics = referenceKinematics';
lhsKinematics = sampleSurrogateKinematicsFromSettings(model, ...
    referenceKinematics, coordinateNames, settings);

[~, trialName, ~] = fileparts(referenceKinematicsFile);
if ~exist(surrogateDataDirectoryName, "dir")
mkdir(surrogateDataDirectoryName);
end
if ~exist(fullfile(surrogateDataDirectoryName, "MAData"), "dir")
    mkdir(fullfile(surrogateDataDirectoryName, "MAData"));
end
if ~exist(fullfile(surrogateDataDirectoryName, "MAData", trialName), "dir")
    mkdir(fullfile(surrogateDataDirectoryName, "MAData", trialName));
end
if ~exist(fullfile(surrogateDataDirectoryName, "IKData"), "dir")
    mkdir(fullfile(surrogateDataDirectoryName, "IKData"));
end
ikFileName = fullfile(surrogateDataDirectoryName, "IKData", ...
    trialName + ".sto");
if isfile(ikFileName)
    warning("Overwriting existing kinematics file.")
    delete(ikFileName);
end
writeToSto(coordinateNames, (1 : size(lhsKinematics, 1)) * 1e-3, ...
    lhsKinematics, ikFileName);

function lhsKinematics = sampleSurrogateKinematicsFromSettings(model, ...
    referenceKinematics, coordinateNames, settings)
rng(42);
upperPadding = zeros(1, length(coordinateNames));
lowerPadding = zeros(1, length(coordinateNames));
maxValues = zeros(1, length(coordinateNames));
minValues = zeros(1, length(coordinateNames));
for j = 1 : length(coordinateNames)
    try
        coordinate = model.getCoordinateSet().get(coordinateNames(j));
    catch
        throw(MException('', "Coordinate " + coordinateNames(j) + ...
            " is not in model"))
    end

    if isfield(settings.padding, coordinateNames(j))
        upperPadding(j) = max(settings.padding.(coordinateNames(j)));
        lowerPadding(j) = min(settings.padding.(coordinateNames(j)));
    else
        if coordinate.getMotionType().toString().toCharArray()' ...
                == "Rotational"
            upperPadding(j) = settings.angularPadding;
            lowerPadding(j) = -settings.angularPadding;
        else
            upperPadding(j) = settings.linearPadding;
            lowerPadding(j) = -settings.linearPadding;
        end
    end

    if coordinate.get_clamped()
        maxValues(j) = coordinate.getRangeMax();
        minValues(j) = coordinate.getRangeMin();
    else
        maxValues(j) = Inf;
        minValues(j) = -Inf;
    end
end

samplePoints = settings.samplePoints;
lhsKinematics = zeros(size(referenceKinematics, 1) * samplePoints, ...
    size(referenceKinematics, 2));
for i = 1 : size(referenceKinematics, 1)
    minima = max([referenceKinematics(i, :) + lowerPadding; minValues]);
    maxima = min([referenceKinematics(i, :) + upperPadding; maxValues]);

    lhs = lhsdesign(samplePoints, length(coordinateNames)) .* ...
        (maxima - minima) + minima;
    lhsKinematics((i - 1) * samplePoints + 1 : i * samplePoints, :) = lhs;
end
end
