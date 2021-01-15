function val = pc_find_const(kData)

kData = squeeze(sum(kData,3)); %sum over slices

% lookup = -pi:0.05:pi;
lookup = -3.14:0.01:3.14;
res    = 0*lookup;

for ii=1:length(lookup)
    res(ii) = pc_test_const(kData,lookup(ii));
end

[~,pos] = min(res);
val = lookup(pos);

end