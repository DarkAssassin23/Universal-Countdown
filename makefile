TARGET = timeRemainingServer
CC = gcc
CFLAGS = -Os

HEADERDIR = headers
SRCDIR = src
CLIENTS = clients

INCLUDES = -I $(HEADERDIR)

OBJDIR = obj

.PHONY: default all clean

default: $(TARGET)
all: default

debug: CFLAGS = -g -Wall
debug: $(TARGET)

debugClient: CFLAGS = -g -Wall
debugClient: client

debugAll: debug debugClient

SERVEROBJECTS = $(patsubst %.c, $(OBJDIR)/%.o, $(wildcard $(SRCDIR)/*.c))
ifeq ($(OS),Windows_NT)
	LIBS = -lws2_32
	CLIENTOBJECTS = $(patsubst %.c, $(OBJDIR)/%.o, \
		$(filter-out $(CLIENTS)/client.c, $(CLIENTS)/*.c))
	CLIENTOBJECTS += $(patsubst %.c, $(OBJDIR)/%.o, \
		 $(filter-out $(SRCDIR)/server.c $(SRCDIR)/queue.c, $(SRCDIR)/*.c))
else 
	CLIENTOBJECTS = $(patsubst %.c, $(OBJDIR)/%.o, \
		$(filter-out $(CLIENTS)/clientWin.c, $(wildcard $(CLIENTS)/*.c)))
	CLIENTOBJECTS += $(patsubst %.c, $(OBJDIR)/%.o, \
		$(filter-out $(SRCDIR)/server.c $(SRCDIR)/queue.c, $(wildcard $(SRCDIR)/*.c)))
endif
HEADERS = $(wildcard $(HEADERDIR)/*.h)

$(OBJDIR)/%.o: %.c $(HEADERS)
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

client: $(CLIENTOBJECTS)
	$(CC) $(CLIENTOBJECTS) $(CFLAGS) $(LIBS) -o $@
	@cp configs/client.cfg ./

$(TARGET): LIBS = -lpthread
$(TARGET): $(SERVEROBJECTS)
	$(CC) $(SERVEROBJECTS) $(CFLAGS) $(LIBS) -o $@
	@cp configs/server.cfg ./

all: $(TARGET) client

clean:
	-rm -rf $(OBJDIR) $(TARGET) client *.cfg

cleanClient:
	-rm -rf $(OBJDIR) client *.cfg

cleanServer:
	-rm -rf $(OBJDIR) $(TARGET) *.cfg
