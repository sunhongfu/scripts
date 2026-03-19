% Function for T2* fitting
function [T2star_map, R2star_map, gof_map] = R2s_T2s_fit(Img, TEs, slc)
	dim = size(Img);  
	% Fit each pixel
	ft = fittype( 'exp1' );
	T2star_map = zeros(dim(1),dim(2));
    R2star_map = zeros(dim(1),dim(2));
    gof_map    = cell(dim(1),dim(2));
	COL = dim(2);
	parfor row = 1:dim(1)
		for col= 1:COL
				tmpVec = squeeze(Img(row,col,slc,:));
				if (tmpVec(1)~=0)
					[xData, yData] = prepareCurveData(TEs, tmpVec);
					yData = yData / yData(1); %Normalize the exp.
		
					[f, gof]	   = fit( xData, yData, ft );
					tmp_T2s = -1/f.b;
                    tmp_R2s = -f.b;
                    gof_map{row,col} = gof;
					if tmp_T2s<0
						tmp_T2s = 0;
                        tmp_R2s = 0;
					end
					T2star_map(row,col) = tmp_T2s;
                    R2star_map(row,col) = tmp_R2s;
			    else
					continue
				end
			
		end
	end	
end