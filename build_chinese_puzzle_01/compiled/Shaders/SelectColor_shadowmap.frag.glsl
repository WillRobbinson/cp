#version 450
void main() {
	float opacity;
	opacity = 0.25 - 0.0002;
	if (opacity < 1.0) discard;
}
