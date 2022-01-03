cd rainforest_oracle
mkdir -p pip_wheels
pip3 install wheel
pip3 wheel --prefer-binary --wheel-dir pip_wheels -r requirements.txt
tar -czvf - pip_wheels | split -b 32M - pip_wheels.tar.gz
rm -rf ./pip_wheels
mkdir -p apt_debs && cd apt_debs
cat ../requirements.txt | grep apt-get | cut -c 19- | eval apt-get download $(</dev/stdin)
cd .. && tar -czvf - apt_debs | split -b 32M - apt_debs.tar.gz
rm -rf ./apt_debs
cat $(find . -type f | sort) | sha256sum | awk '{print $1}'
