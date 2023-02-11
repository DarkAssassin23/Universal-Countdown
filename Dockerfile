FROM alpine:latest
WORKDIR /server  
COPY . ./app
RUN apk add make build-base && \
	cd app && make && mv timeRemainingServer ../ && \
	mv server.cfg ../ && \
	apk --purge del make build-base && \
	cd .. && rm -rf app
EXPOSE 8989
CMD ["./timeRemainingServer"]
