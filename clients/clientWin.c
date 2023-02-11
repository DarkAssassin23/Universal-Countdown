#include <windows.h>
#include <winsock2.h>
#include <ws2tcpip.h>
#include <stdlib.h>
#include <stdio.h>

#include "remainingTime.h"
#include "processConfig.h"


#define DEFAULT_PORT "8989"
const char *DEFAULT_SERVER_IP = "127.0.0.1";

int main(int argc, char **argv) 
{

    char* serverip = NULL;
    int serverport = atoi(DEFAULT_PORT);
    char* occasion = NULL;
    processClientConfig(&serverip, &serverport, &occasion);

    if(serverip == NULL)
    {
        serverip = malloc(sizeof(char)*strlen(DEFAULT_SERVER_IP));
        strcpy(serverip, DEFAULT_SERVER_IP);
    }
    char port[6];
    sprintf(port, "%d", serverport);

    WSADATA wsaData;
    SOCKET ConnectSocket = INVALID_SOCKET;
    struct addrinfo *result = NULL,
                    *ptr = NULL,
                    hints;
    char recvbuf[MAX_MSG_SIZE] = {0};
    int iResult;
    int recvbuflen = MAX_MSG_SIZE;

    // Initialize Winsock
    iResult = WSAStartup(MAKEWORD(2,2), &wsaData);
    if (iResult != 0) 
    {
        printf("WSAStartup failed with error: %d\n", iResult);
        return 1;
    }

    ZeroMemory( &hints, sizeof(hints) );
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;

    // Resolve the server address and port
    iResult = getaddrinfo(serverip, port, &hints, &result);
    if ( iResult != 0 ) 
    {
        printf("getaddrinfo failed with error: %d\n", iResult);
        WSACleanup();
        return 1;
    }

    // Attempt to connect to an address until one succeeds
    for(ptr=result; ptr != NULL ;ptr=ptr->ai_next) 
    {

        // Create a SOCKET for connecting to server
        ConnectSocket = socket(ptr->ai_family, ptr->ai_socktype, 
            ptr->ai_protocol);
        if (ConnectSocket == INVALID_SOCKET) 
        {
            printf("socket failed with error: %d\n", WSAGetLastError());
            WSACleanup();
            return 1;
        }

        // Connect to server.
        iResult = connect( ConnectSocket, ptr->ai_addr, (int)ptr->ai_addrlen);
        if (iResult == SOCKET_ERROR) 
        {
            closesocket(ConnectSocket);
            ConnectSocket = INVALID_SOCKET;
            continue;
        }
        break;
    }

    freeaddrinfo(result);

    if (ConnectSocket == INVALID_SOCKET) 
    {
        printf("Unable to connect to server!\n");
        WSACleanup();
        return 1;
    }

    iResult = recv(ConnectSocket, recvbuf, recvbuflen, 0);
    if ( iResult > 0 )
    {
        if(occasion == NULL)
            printf("%s",recvbuf);
        else
        {
            printf("Time remaining until %s:",occasion);
            strtok(recvbuf, ":");
            char* timeLeft = strtok(NULL, ":");
            if(timeLeft == NULL)
                printf(" %s",recvbuf);
            else
                printf("%s",timeLeft);
        }
    }
        
    //printf("Bytes received: %d\n", iResult);
    else if ( iResult == 0 )
        printf("Connection closed\n");
    else
        printf("recv failed with error: %d\n", WSAGetLastError());

    // cleanup
    closesocket(ConnectSocket);
    WSACleanup();

    return 0;
}