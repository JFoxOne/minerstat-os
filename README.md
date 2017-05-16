# <a href="https://minerstat.com" target="_blank">minerstat.com</a> - Linux Client
Nvidia & AMD

<b>Features:</b>
- Coin Algorithm
- Dual-Mining Algorithm
- Send miner log file to the server
- Send miner data to the server (GPU, HASHRATE, etc..)
- Remote commands (Restart miner, Reboot PC, Change miner)
- Watchdog 

# Before you start..
Enter this lines on linux terminal..
<pre>
apt update
apt dist-upgrade
apt install nodejs-legacy ocl-icd-opencl-dev libcurl3:i386 libcurl4-openssl-dev unzip git
</pre>

# Download
the node to your home folder..
<pre>
git clone https://github.com/coinscrow/minerstat-linux
</pre>

# Edit Config
<pre>
nano config.js
</pre>

<pre>
// EDIT THIS LINES BELOW TO CONFIGURE YOUR WORKER

global.accesskey = "<b>YOURMINERSTATLOGINKEYHERE</b>"; // minerstat.com LOGIN key
global.worker = "<b>YOURRIGNAMEHERE</b>"; // your created worker at the website
global.client = "<b>claymore-eth</b>";

// global.client EXAMPLES:
// NVIDIA: ewbf-zec
// AMD: claymore-zec
// NVIDIA & AMD: claymore-eth, claymore-etc, claymore-exp, claymore-music, claymore-ubq
// claymore-eth ALGO & DUAL-MINING ALGO: algo
</pre>

# Start the client
on it's folder..
<pre>
node start
</pre>


<br>
<center>--------------------------------- © 2017 minerstat.com -------------------------------------</center>
