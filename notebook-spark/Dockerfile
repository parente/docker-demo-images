FROM debian:jessie

MAINTAINER Jupyter Project <jupyter@googlegroups.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -yq --no-install-recommends \
    openjdk-7-jre-headless \
    git \
    vim \
    wget \
    build-essential \
    python-dev \
    ca-certificates \
    bzip2 \
    unzip \
    libsm6 \
    && apt-get clean

ENV CONDA_DIR /opt/conda
ENV NB_USER jovyan

# Install conda
RUN echo 'export PATH=$CONDA_DIR/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-3.9.1-Linux-x86_64.sh && \
    /bin/bash /Miniconda3-3.9.1-Linux-x86_64.sh -b -p $CONDA_DIR && \
    rm Miniconda3-3.9.1-Linux-x86_64.sh && \
    $CONDA_DIR/bin/conda install --yes conda==3.14.1

# Create non-root user
RUN useradd -m -s /bin/bash $NB_USER
RUN chown -R $NB_USER:$NB_USER $CONDA_DIR
RUN chown $NB_USER:$NB_USER /home/$NB_USER -R

# Install Spark
RUN wget -qO - http://d3kbcqa49mib13.cloudfront.net/spark-1.4.0-bin-hadoop2.6.tgz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s spark-1.4.0-bin-hadoop2.6 spark

# Install Scala Spark kernel


# Install Python packages
USER $NB_USER
ENV HOME /home/$NB_USER
ENV SHELL /bin/bash
ENV USER $NB_USER
ENV WORK $HOME/work
ENV PATH $CONDA_DIR/bin:$PATH
RUN conda install --yes \
    ipython-notebook==3.2 \
    pandas==0.16 \
    matplotlib==1.4 \
    scipy==0.15 \
    seaborn==0.6 \
    scikit-learn==0.16 \
    terminado \
    && conda clean -yt

# Configure Jupyter
RUN ipython profile create

# Configure environment
ENV SPARK_HOME /usr/local/spark
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.8.2.1-src.zip:$WORK
WORKDIR $HOME
EXPOSE 8888
CMD ipython notebook

# Add local files as late as possible to avoid cache busting
COPY ipython_notebook_config.py $HOME/.ipython/profile_default/