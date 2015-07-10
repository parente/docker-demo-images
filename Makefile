images: minimal-image demo-image

minimal-image:
	docker build -t jupyter/minimal common/

demo-image: minimal-image
	docker build -t jupyter/demo .

spark-image:
	docker build -t jupyter/notebook-spark notebook-spark/

upload: images
	docker push jupyter/notebook-spark
	docker push jupyter/minimal
	docker push jupyter/demo

super-nuke: nuke
	-docker rmi jupyter/minimal
	-docker rmi jupyter/demo
	-docker rmi jupyter/notebook-spark

# Cleanup with fangs
nuke:
	-docker stop `docker ps -aq`
	-docker rm -fv `docker ps -aq`
	-docker images -q --filter "dangling=true" | xargs docker rmi

.PHONY: nuke
