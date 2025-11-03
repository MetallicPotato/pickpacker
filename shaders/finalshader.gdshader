shader_type canvas_item;

global uniform sampler2D redtexture;
global uniform sampler2D greentexture;
global uniform sampler2D bluetexture;
global uniform sampler2D alphatexture;
global uniform int redmode;
global uniform int greenmode;
global uniform int bluemode;
global uniform int alphamode;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	switch (redmode) {
		case 0:
			COLOR.r = texture(redtexture, UV).r;
			break;
		case 1:
			COLOR.r = texture(redtexture, UV).g;
			break;
		case 2:
			COLOR.r = texture(redtexture, UV).b;
			break;
		case 3:
			COLOR.r = texture(redtexture, UV).a;
			break;
	}
	switch (greenmode) {
		case 0:
			COLOR.g = texture(greentexture, UV).r;
			break;
		case 1:
			COLOR.g = texture(greentexture, UV).g;
			break;
		case 2:
			COLOR.g = texture(greentexture, UV).b;
			break;
		case 3:
			COLOR.g = texture(greentexture, UV).a;
			break;
	}
	switch (bluemode) {
		case 0:
			COLOR.b = texture(bluetexture, UV).r;
			break;
		case 1:
			COLOR.b = texture(bluetexture, UV).g;
			break;
		case 2:
			COLOR.b = texture(bluetexture, UV).b;
			break;
		case 3:
			COLOR.b = texture(bluetexture, UV).a;
			break;
	}
	switch (alphamode) {
		case 0:
			COLOR.a = texture(alphatexture, UV).r;
			break;
		case 1:
			COLOR.a = texture(alphatexture, UV).g;
			break;
		case 2:
			COLOR.a = texture(alphatexture, UV).b;
			break;
		case 3:
			COLOR.a = texture(alphatexture, UV).a;
			break;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
