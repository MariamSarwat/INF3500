#include <cmath>
#include <stdlib.h>
#include <iostream>
#include <iomanip>
#include <sstream>
#include <fstream>


#define ROTRIGHT(a,b) (((a) >> (b)) | ((a) << (32-(b))))

#define ch(x,y,z) (((x) & (y)) ^ (~(x) & (z)))
#define maj(x,y,z) (((x) & (y)) ^ ((x) & (z)) ^ ((y) & (z)))

#define sigma_0(x) (ROTRIGHT(x,2) ^ ROTRIGHT(x,13) ^ ROTRIGHT(x,22))
#define sigma_1(x) (ROTRIGHT(x,6) ^ ROTRIGHT(x,11) ^ ROTRIGHT(x,25))

using namespace std;

string format(uint32_t x) {
	stringstream sortie;
	sortie << setw(8) << hex << setfill('0') << x;
	return sortie.str();
}

static const int K = 0x428a2f98l;

uint32_t entry[64] = {
		0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
		0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
		0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
		0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
		0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
		0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
		0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
		0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
};

int main() {
	uint32_t H0, H1, H2, H3, H4, H5, H6, H7, W, a, b, c, d, e, f, g, h, temp1, temp2;
	ofstream fff("bench.txt");

	short etat = 0;
	bool reset = true;

	if (reset) {
		H0 = 0x6a09e667;
		H1 = 0xbb67ae85;
		H2 = 0x3c6ef372;
		H3 = 0xa54ff53a;
		H4 = 0x510e527f;
		H5 = 0x9b05688c;
		H6 = 0x1f83d9ab;
		H7 = 0x5be0cd19;
		W = 0x00000000;
		reset = false;
	}

	for (int i = 0; i < 64; i++) {
		if (entry[i] != W) etat = 1;
		switch (etat) {
	
		case 1:
			a = H0;
			b = H1;
			c = H2;
			d = H3;
			e = H4;
			f = H5;
			g = H6;
			h = H7;
			W = entry[i];
			etat++;

		case 2:
			temp1 = h + sigma_1(e) + ch(e, f, g) + K + W;
			temp2 = sigma_0(a) + maj(a, b, c);
			h = g;
			g = f;
			f = e;
			etat++;

		case 3:
			e = d + temp1;
			d = c;
			c = b;
			b = a;
			a = temp1 + temp2;
			etat++;

		case 4:
			H0 = a + H0;
			H1 = b + H1;
			H2 = c + H2;
			H3 = d + H3;
			H4 = e + H4;
			H5 = f + H5;
			H6 = g + H6;
			H7 = h + H7;
			etat++;

		case 5:
			fff << "x\"" << format(H0) << format(H1) << format(H2) << format(H3) << format(H4) << format(H5) << format(H6) << format(H7) << "\"," << endl;
			break;
		}

	}
	system("pause");
}