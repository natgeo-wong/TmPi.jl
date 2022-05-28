struct TmPiDefault{FT<:Real} <: TmPiDataset

    ts :: Array{Float32,2}
    td :: Array{Float32,2}
    sp :: Array{Float32,2}
    ta :: Array{Float32,3}
    sh :: Array{Float32,3}

    tmp2D :: Array{Int16,2}
    tmp3D :: Array{Int16,3}

    tm :: Array{Float32,3}
    Pi :: Array{Float32,3}

    lsd :: LandSea{FT}
    p   :: Vector{Int16}

end

struct TmPiPrecise{FT<:Real} <: TmPiDataset

    ts :: Array{Float32,2}
    td :: Array{Float32,2}
    sp :: Array{Float32,2}
    ta :: Array{Float32,3}
    sh :: Array{Float32,3}

    tmp2D :: Array{Int16,2}

    tm :: Array{Float32,3}
    Pi :: Array{Float32,3}

    lsd :: LandSea{FT}
    p   :: Vector{Int16}

end

function TmPiDataset(
    e5ds :: ERA5Hourly;
    isprecise :: Bool = false,
    FT = Float32
)

    p = era5Pressures(); p = p[p.>=50]; np = length(p)

    @info "$(modulelog()) - Loading Global LandSea dataset (0.25º resolution)"
    lsd  = getLandSea(e5ds,ERA5Region(GeoRegion("GLB"),gres=0.25))
    nlon = length(lsd.lon)
    nlat = length(lsd.lat)

    @info "$(modulelog()) - Preallocating arrays for downloaded ERA5 datasets"
    ts = zeros(Float32,nlon,nlat)
    td = zeros(Float32,nlon,nlat)
    sp = zeros(Float32,nlon,nlat)
    ta = zeros(Float32,nlon,nlat,np)
    sh = zeros(Float32,nlon,nlat,np)

    @info "$(modulelog()) - Preallocating temporary arrays to load raw data from NetCDF"
    tmp2D = zeros(Int16,nlon,nlat)
    tmp3D = zeros(Int16,nlon,nlat,np)

    @info "$(modulelog()) - Preallocating arrays for final Tm and Pi data"
    tm = zeros(Float32,nlon,nlat,744) # 31*24 = 744
    Pi = zeros(Float32,nlon,nlat,744) # 31*24 = 744

    if isprecise
        return TmPiPrecise{FT}(
            ts, td, sp, ta, sh,
            tmp2D,
            tm, Pi, lsd, p
        )
    else
        return TmPiDefault{FT}(
            ts, td, sp, ta, sh,
            tmp2D, tmp3D,
            tm, Pi, lsd, p
        )
    end

end