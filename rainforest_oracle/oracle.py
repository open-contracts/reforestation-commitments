
import opencontracts
import os
from earthdata import Auth, DataGranules, Accessor
from datetime import datetime
from osgeo import gdal
import numpy as np
import cartopy.io.shapereader as shp
import shapely.geometry as sgeom

with opencontracts.enclave_backend() as enclave:
  yr, mo = enclave.user_input('Year-Month (YY-MM)').split('-')
  yr, mo = int(yr), int(mo)

  os.environ["CMR_USERNAME"] = enclave.user_input('Username for NASA Earthdata API:')
  os.environ["CMR_PASSWORD"] = enclave.user_input('Password for NASA Earthdata API:')
  auth = Auth()
  auth.login(strategy='environment')

  # https://lpdaac.usgs.gov/products/mod13c1v006/
  granules = DataGranules(auth).short_name('MOD13C1').version('006').temporal(
      date_from=datetime(2000+yr, mo, 1).isoformat(),
      date_to=datetime(2000+yr, mo, 1).isoformat()
    )
  Accessor(auth).get(granules.get(), './dl')
  data = gdal.Open(gdal.Open('./dl/'+os.listdir('./dl')[0]).GetSubDatasets()[0][0])
  ndvi = data.ReadAsArray()[1600:2500,2000:3000] * 0.0001

  countries = shp.Reader(shp.natural_earth(category='cultural', name='admin_0_countries')).records()
  brazil = list(filter(lambda c:c.attributes['ISO_A3'] == 'BRA', countries))[0].geometry
  x, y = np.meshgrid(np.arange(2000,3000), np.arange(1600,2500))
  xoff, a, b, yoff, d, e = data.GetGeoTransform()
  contained = lambda x, y: brazil.contains(sgeom.Point(a*x+b*y+a/2+b/2+xoff, d*x+e*y+d/2+e/2+yoff))
  in_brazil = np.vectorize(contained)(x, y)

  rainforest_share = (ndvi > 0.7)[in_brazil].mean()
  rainforest_km2 = rainforest_share * 8515770    # times size of brazil
  enclave.print(f'Validated rainforest size of {rainforest_km2} km^2 in {mo}-20{yr}')
  enclave.submit(rainforest_km2, mo, yr, types=('uint256', 'uint8', 'uint8',), function_name='measure_rainforest')