FROM amazonlinux:2

# Make sure the package repository is up to date and install essential tools
RUN yum update -y && \
    yum install -y git && \
    yum install -y openssh-server && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    yum install -y java-11-openjdk-devel && \
    yum install -y maven && \
    yum clean all && \
    rm -rf /var/cache/yum

# Add user jenkins to the image
RUN useradd -m -d /home/jenkins jenkins && \
    echo "jenkins:password" | chpasswd && \
    mkdir /home/jenkins/.m2

# Copy authorized keys
COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys

RUN chown -R jenkins:jenkins /home/jenkins/.m2/ && \
    chown -R jenkins:jenkins /home/jenkins/.ssh/

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
