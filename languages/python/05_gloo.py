#http://www.labri.fr/perso/nrougier/teaching/opengl/

import sys
import numpy as np
import OpenGL.GL as gl
import OpenGL.GLUT as glut
from vispy import gloo
from vispy.gloo import Program, VertexBuffer, IndexBuffer
from transforms import perspective, translate, rotate

vertex = """
	uniform mat4 model;
	uniform mat4 view;
	uniform mat4 projection
	uniform vec4 color;
    attribute vec3 position;
    varying vec4 v_color;
    void main()
    {
		v_color = color
		gl_Position = projections * view * model * vec4(position,1.0)
	}"""
	
fragment = """
    varying vec4 v_color;
    void main()
    {
        gl_FragColor = v_color;
    } """
	
clockRate = 0.005
	
def timer(fps):
	global clock
	global theta, phi
	theta += 0.5
	phi += 0.5
	model = np.eye(4, dtype=np.float32)
	rotate(model, theta, 0, 0, 1)
	rotate(model, phi, 0, 1, 0)
	program['model'] = model
	clock += clockRate * 1000.0/fps
	#program['scale'] = np.cos(clock)
	#program['angle']+=0.05
	glut.glutTimerFunc(1000/fps,timer,fps)
	glut.glutPostRedisplay()

def changeSomething():
	global clockRate
	clockRate = clockRate *1.1
	
def display():
	gl.glClear(gl.GL_COLOR_BUFFER_BIT | gl.GL_DEPTH_BUFFER_BIT)
	program.draw(gl.GL_TRIANGLES)
	glut.glutSwapBuffers()
	
def reshape(width,height):
#	side = min(width,height)
	gl.glViewport(0,0,width,height)
	projection = perspective (45.0, width/float(height), 2.0, 10.0 )
	program['projection'] = projection
#	gl.glViewport((width-side)/2,(height-side)/2,side,side)

	
def keyboard(key, x, y):
	if key == '\033':
		sys.exit()
	elif key == ' ':
		print "You hit space"
		changeSomething()

glut.glutInit(sys.argv)
glut.glutInitDisplayMode(glut.GLUT_DOUBLE | glut.GLUT_RGBA | glut.GLUT_DEPTH)
glut.glutCreateWindow('Hello World')
glut.glutReshapeWindow(512,512)
glut.glutReshapeFunc(reshape)
glut.glutKeyboardFunc(keyboard)
glut.glutDisplayFunc(display)
glut.glutTimerFunc(1000/60, timer, 60)

gl.glClearColor(1,1,1,1)
gl.glEnable(gl.GL_DEPTH_TEST)


V = np.zeros(8, dtype=[("position", np.float32, 3)])
V["position"] = [[ 1, 1, 1], [-1, 1, 1], [-1,-1, 1], [ 1,-1, 1],
				[ 1,-1,-1], [ 1, 1,-1], [-1, 1,-1], [-1,-1,-1]]
I = [0,1,2, 0,2,3,  0,3,4, 0,4,5,  0,5,6, 0,6,1,
	 1,6,7, 1,7,2,  7,4,3, 7,3,2,  4,7,6, 4,6,5]
vertices = gloo.VertexBuffer(V)
indices = gloo.IndexBuffer(I)

program = Program(vertex, fragment)
program.bind(vertices)
program['color'] = 1,0,0,1
clock = 0


view = np.eye(4,dtype=np.float32)
model = np.eye(4,dtype=np.float32)
projection = np.eye(4,dtype=np.float32)
translate(view,0,0,-5)
program['model'] = model
translate(view,0,0,-5)
program['view'] = view
program['projection'] = projection	
phi, theta = 0,0


glut.glutMainLoop()
	
