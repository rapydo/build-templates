FROM stilliard/pure-ftpd:stretch-latest


COPY ./ftp_utilities.sh /usr/local/bin/myftp
RUN chmod +x /usr/local/bin/myftp


RUN echo "Use 'myftp' command to create/modify users" >> /root/.bashrc


# startup
CMD /run.sh -c 50 -C 10 -l puredb:/etc/pure-ftpd/pureftpd.pdb -E -j -R -P $PUBLICHOST -p 30000:30019

EXPOSE 21 30000-30019
