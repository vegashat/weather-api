{application,open_cagex,
             [{applications,[kernel,stdlib,elixir,httpoison,poison]},
              {description,"An OpenCage Geocoder API wrapper written in Elixir"},
              {modules,['Elixir.OpenCagex','Elixir.OpenCagex.Api',
                        'Elixir.OpenCagex.Config','Elixir.OpenCagex.Parser',
                        'Elixir.OpenCagex.Response']},
              {registered,[]},
              {vsn,"0.1.3"},
              {env,[{api_key,nil},
                    {api_url,<<"http://api.opencagedata.com/geocode/v1/">>}]}]}.