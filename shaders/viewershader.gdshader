shader_type canvas_item;

instance uniform int mode = 0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = texture(TEXTURE, UV);
	switch (mode) {
		case 0:
			//Normal View
			break;
		case 1:
			//Red View
			COLOR.r = COLOR.r;
			COLOR.g = COLOR.r;
			COLOR.b = COLOR.r;
			break;
		case 2:
			//Green View
			COLOR.r = COLOR.g;
			COLOR.g = COLOR.g;
			COLOR.b = COLOR.g;
			break;
		case 3:
			//Blue View
			COLOR.r = COLOR.b;
			COLOR.g = COLOR.b;
			COLOR.b = COLOR.b;
			break;
		case 4:
			//Alpha View
			COLOR.r = COLOR.a;
			COLOR.b = COLOR.a;
			COLOR.g = COLOR.a;
			break;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
