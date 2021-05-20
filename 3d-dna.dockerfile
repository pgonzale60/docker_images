FROM continuumio/miniconda3:4.9.2
LABEL authors="pg17@ssanger.ac.uk" \
      description="Docker image containing 3D-DNA pipeline"
ENV CONTAINER_VERSION=0.0.2

# This is neccesary for succesful installation of Java
RUN mkdir /usr/share/man/man1/

# Install java among other dependencies and
# deep clean the apt cache to reduce image/layer size
RUN apt-get update \
      && apt-get install -y --no-install-recommends default-jre gawk parallel git \
      && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install python dependencies and clean cache
RUN /bin/sh -c conda install -y scipy numpy matplotlib && \
	  conda clean -tiy

# Get pipeline and install
RUN /bin/sh -c cd / && \
	  git clone https://github.com/aidenlab/3d-dna.git && \
	  chmod +x /3d-dna/run-asm-pipeline.sh && \
	  ln -s /3d-dna/run-asm-pipeline.sh /usr/bin/run-asm-pipeline.sh && \
	  chmod +x /3d-dna/run-asm-pipeline-post-review.sh && \
	  ln -s /3d-dna/run-asm-pipeline-post-review.sh /usr/bin/run-asm-pipeline-post-review.sh
