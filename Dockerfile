FROM amazoncorretto:20-alpine

RUN apk update && apk upgrade
RUN apk add py3-pip

RUN apk add gcc musl-dev linux-headers python3-dev curl
RUN pip3 install --no-cache-dir jupyter jupyterlab

USER root

# Download the kernel release
RUN curl -L https://github.com/padreati/rapaio-jupyter-kernel/releases/download/1.2.1/rapaio-jupyter-kernel-1.2.1.jar > rapaio-jupyter-kernel-1.2.1.jar


# Set up the user environment

ENV NB_USER rjk
ENV NB_UID 1000
ENV HOME /home/$NB_USER

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid $NB_UID \
    $NB_USER

COPY . $HOME
RUN chown -R $NB_UID $HOME

USER $NB_USER

# Unpack and install the kernel
RUN java -jar ./rapaio-jupyter-kernel-1.2.1.jar -i -auto

# Launch the notebook server
WORKDIR $HOME
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
EXPOSE 8888
