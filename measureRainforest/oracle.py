import opencontracts
import os, geojson
from earthdata import Auth, DataGranules, Accessor
from datetime import datetime
from pyhdf.SD import SD, SDC
import numpy as np
import matplotlib.path as mpath

with opencontracts.session() as session:
  yr = int(session.user_input('Enter the year in which the forest should be measured:').split('/'))
  date = datetime(2000+yr, 1, 1).isoformat()
  os.environ["CMR_USERNAME"] = session.user_input('Username for NASA Earthdata API:')
  os.environ["CMR_PASSWORD"] = session.user_input('Password for NASA Earthdata API:')
  auth = Auth()
  assert auth.login(strategy='environment'), "Invalid Credentials" 
  # Data Info: https://lpdaac.usgs.gov/products/mod13c1v006/
  session.expect_delay(60, "Downloading Amazon Rainforest Satellite Images...")
  granules = DataGranules(auth).short_name('MOD13C1').version('006').temporal(date_from=date,date_to=date)
  Accessor(auth).get(granules.get(), './dl')
  ndvi = SD('./dl/'+os.listdir('./dl')[0], SDC.READ).select(
      'CMG 0.05 Deg 16 days NDVI'
    ).get()[1600:2500,2000:3000] * 0.0001

  x, y = np.meshgrid(np.arange(2000,3000), np.arange(1600,2500))
  lon, lat = 0.05*(x+0.5)-180, 90-0.05*(y+0.5)
  with open('brazil.geojson', 'r') as f: brazil = geojson.load(f)['geometry']
  path = mpath.Path(brazil['coordinates'][-1][0], closed=True)
  in_brazil = path.contains_points(list(zip(lon.flatten(), lat.flatten()))).reshape(lon.shape)

  rainforest_share = (ndvi > 0.8)[in_brazil].mean()
  rainforest_km2 = int(rainforest_share * 8500000)    # times size of brazil

  session.print(f'Validated rainforest size of {rainforest_km2} km^2 in {mo}-20{yr}')
  session.submit(rainforest_km2, mo, yr, types=('uint256', 'uint8', 'uint8',), function_name='measureRainforest')
