## HOW TO SETUP

**Using git**
```sh
mkdir -p ~/storage \
  git clone --single-branch --depth 1 -b config https://github.com/msalmanrafadhlih/termux.git ~/storage/termux-app \
  chmod +x ~/storage/termux-app/starter.sh \
  ~/storage/termux-app/starter.sh
```

**Setup using wget**
```sh
mkdir -p ~/.cache && \
wget -qO ~/.cache/starter.sh \
https://raw.githubusercontent.com/msalmanrafadhlih/termux/config/starter.sh && \
  chmod +x ~/.cache/starter.sh && \
  ~/.cache/starter.sh
```

**Using curl**
```sh
bash <(curl -fsSL "https://raw.githubusercontent.com/msalmanrafadhlih/termux/config/starter.sh")
```
