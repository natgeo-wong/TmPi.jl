function download(
    tmpi :: TmPiDataset,
    date :: Date,
    evar :: Vector{SingleVariable{String}},
)

    ckeys = cdskey()

    @info "$(modulelog()) - Using CDSAPI in Julia to download SINGLE-LEVEL $(uppercase(tmpi.name)) data in the Global Region (Horizontal Resolution: 0.25) for $(date)."
    flush(stderr)

    fnc = joinpath(tmpi.path,"tmpnc-single-$(date).nc")
    fol = dirname(fnc); if !isdir(fol); mkpath(fol) end

    e5dkey = Dict(
        "product_type" => tmpi.ptype,
        "year"         => year(date),
        "month"        => month(date),
        "day"          => collect(1:31),
        "variable"     => [evarii.long for evarii in evar],
        "area"         => [90, 0, -90, 360],
        "grid"         => [0.25, 0.25],
        "time"         => [
            "00:00", "01:00", "02:00", "03:00", "04:00", "05:00",
            "06:00", "07:00", "08:00", "09:00", "10:00", "11:00",
            "12:00", "13:00", "14:00", "15:00", "16:00", "17:00",
            "18:00", "19:00", "20:00", "21:00", "22:00", "23:00",
        ],
        "format"       => "netcdf",
    )
    
    if !isfile(fnc)
        tryretrieve = 0
        while isinteger(tryretrieve) && (tryretrieve < 20)
            try
                retrieve("reanalysis-era5-single-levels",e5dkey,fnc,ckeys)
                flush(stderr)
                tryretrieve += 0.5
            catch
                tryretrieve += 1
                @info "$(modulelog()) - Failed to retrieve/request data from CDSAPI on Attempt $(tryretrieve) of 20"
                flush(stderr)
            end
        end
        if tryretrieve == 20
            @warn "$(modulelog()) - Failed to retrieve/request data, skipping to next set of requests"
            flush(stderr)
        end
    end

end

function download(
    tmpi :: TmPiDefault,
    date :: Date,
    evar :: Vector{PressureVariable{String}}
)

    ckeys = cdskey()

    @info "$(modulelog()) - Using CDSAPI in Julia to download PRESSURE-LEVEL $(uppercase(tmpi.name)) data in the Global Region (Horizontal Resolution: 0.25) for $(date)."
    flush(stderr)

    for evarii in evar

        fnc = joinpath(tmpi.path,"tmpnc-pressure-$(evarii.ID)-$(date).nc")
        fol = dirname(fnc); if !isdir(fol); mkpath(fol) end

        e5dkey = Dict(
            "product_type"   => tmpi.ptype,
            "year"           => year(date),
            "month"          => month(date),
            "day"            => collect(1:31),
            "variable"       => evarii.long,
            "pressure_level" => tmpi.p ./ 100,
            "area"           => [90, 0, -90, 360],
            "grid"           => [0.25, 0.25],
            "time"           => [
                "00:00", "01:00", "02:00", "03:00", "04:00", "05:00",
                "06:00", "07:00", "08:00", "09:00", "10:00", "11:00",
                "12:00", "13:00", "14:00", "15:00", "16:00", "17:00",
                "18:00", "19:00", "20:00", "21:00", "22:00", "23:00",
            ],
            "format"         => "netcdf",
        )
        
        if !isfile(fnc)
            tryretrieve = 0
            while isinteger(tryretrieve) && (tryretrieve < 20)
                try
                    retrieve("reanalysis-era5-pressure-levels",e5dkey,fnc,ckeys)
                    flush(stderr)
                    tryretrieve += 0.5
                catch
                    tryretrieve += 1
                    @info "$(modulelog()) - Failed to retrieve/request data from CDSAPI on Attempt $(tryretrieve) of 20"
                    flush(stderr)
                end
            end
            if tryretrieve == 20
                @warn "$(modulelog()) - Failed to retrieve/request data, skipping to next set of requests"
                flush(stderr)
            end
        end

    end

end

function download(
    tmpi :: TmPiPrecise,
    date :: Date,
    evar :: Vector{PressureVariable{String}}
)

    ckeys = cdskey()

    @info "$(modulelog()) - Using CDSAPI in Julia to download PRESSURE-LEVEL $(uppercase(tmpi.name)) data in the Global Region (Horizontal Resolution: 0.25) for $(date)."
    flush(stderr)

    for ip in tmpi.p

        fnc = joinpath(tmpi.path,"tmpnc-pressure-$ip-$(date).nc")
        fol = dirname(fnc); if !isdir(fol); mkpath(fol) end

        e5dkey = Dict(
            "product_type"   => tmpi.ptype,
            "year"           => year(date),
            "month"          => month(date),
            "day"            => collect(1:31),
            "variable"       => [evarii.long for evarii in evar],
            "pressure_level" => ip ./ 100,
            "area"           => [90, 0, -90, 360],
            "grid"           => [0.25, 0.25],
            "time"           => [
                "00:00", "01:00", "02:00", "03:00", "04:00", "05:00",
                "06:00", "07:00", "08:00", "09:00", "10:00", "11:00",
                "12:00", "13:00", "14:00", "15:00", "16:00", "17:00",
                "18:00", "19:00", "20:00", "21:00", "22:00", "23:00",
            ],
            "format"         => "netcdf",
        )

        if !isfile(fnc)
            tryretrieve = 0
            while isinteger(tryretrieve) && (tryretrieve < 20)
                try
                    retrieve("reanalysis-era5-pressure-levels",e5dkey,fnc,ckeys)
                    tryretrieve += 0.5
                    flush(stderr)
                catch
                    tryretrieve += 1
                    @info "$(modulelog()) - Failed to retrieve/request data from CDSAPI on Attempt $(tryretrieve) of 20"
                    flush(stderr)
                end
            end
            if tryretrieve == 20
                @warn "$(modulelog()) - Failed to retrieve/request data, skipping to next set of requests"
                flush(stderr)
            end
        end

    end

end