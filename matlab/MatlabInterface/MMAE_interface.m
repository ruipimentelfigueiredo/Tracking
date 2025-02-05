%CLASS_INTERFACE Example MATLAB class wrapper to an underlying C++ class
classdef MMAE_interface < handle
    properties (SetAccess = private, Hidden = true)
        objectHandle; % Handle to the underlying C++ class instance
    end
    methods
        %% Constructor - Create a new C++ class instance 
        function this = MMAE_interface_interface(varargin)
            this.objectHandle = MMAE_interface_mex('new', varargin{:});
        end
        
        %% Destructor - Destroy the C++ class instance
        function delete(this)
            MMAE_interface_mex('delete', this.objectHandle);
        end

        %% Methods
        function varargout = getStatePrediction(this, varargin)
            [varargout{1:nargout}] = MMAE_interface_mex('getStatePrediction', this.objectHandle, varargin{:});
        end
        
        function varargout = getStateCovariancePrediction(this, varargin)
            [varargout{1:nargout}] = MMAE_interface_mex('getStateCovariancePrediction', this.objectHandle, varargin{:});
        end

        function varargout = getStatePosterior(this, varargin)
            [varargout{1:nargout}] = MMAE_interface_mex('getStatePosterior', this.objectHandle, varargin{:});
        end
        
        function varargout = getStateCovariancePosterior(this, varargin)
            [varargout{1:nargout}] = MMAE_interface_mex('getStateCovariancePosterior', this.objectHandle, varargin{:});
        end
        
        function varargout = predict(this, varargin)
            [varargout{1:nargout}] = MMAE_interface_mex('predict', this.objectHandle, varargin{:});
        end
        
        function varargout = update(this, varargin)
            [varargout{1:nargout}] = MMAE_interface_mex('update', this.objectHandle, varargin{:});
        end

        function varargout = getAllModelProbabilities(this, varargin)
            [varargout{1:nargout}] = MMAE_interface_mex('getAllModelProbabilities', this.objectHandle, varargin{:});
        end

    end
end
