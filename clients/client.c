#include <arpa/inet.h> // inet_addr()
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h> // bzero()
#include <sys/socket.h>
#include <unistd.h> // read(), write(), close()

#include "remainingTime.h"
#include "processConfig.h"

#define DEFAULT_PORT 8989
#define SA struct sockaddr
const char *DEFAULT_SERVER_IP = "127.0.0.1";
 
int main()
{
    char* serverip = NULL;
    int serverport = DEFAULT_PORT;
    char* occasion = NULL;
    processClientConfig(&serverip, &serverport, &occasion);

    if(serverip == NULL)
    {
        serverip = malloc(sizeof(char)*strlen(DEFAULT_SERVER_IP));
        strcpy(serverip, DEFAULT_SERVER_IP);
    }

    int sockfd;
    struct sockaddr_in servaddr;
 
    // socket create and verification
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        printf("socket creation failed...\n");
        exit(0);
    }

    bzero(&servaddr, sizeof(servaddr));
 
    // assign IP, PORT
    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr = inet_addr(serverip);
    servaddr.sin_port = htons(serverport);
 
    // connect the client socket to server socket
    if (connect(sockfd, (SA*)&servaddr, sizeof(servaddr))
        != 0) {
        printf("connection with the server failed...\n");
        exit(0);
    }

    // initialize the buffer
    char buff[MAX_MSG_SIZE] = {0};
    read(sockfd, buff, sizeof(buff));
    printf("%s\n",buff);
    if(occasion == NULL)
        printf("%s",buff);
    else
    {
        printf("Time remaining until %s:",occasion);
        strtok(buff, ":");
        char* timeLeft = strtok(NULL, ":");
        if(timeLeft == NULL)
            printf(" %s",buff);
        else
            printf("%s",timeLeft);
    }
 
    // close the socket
    close(sockfd);
}