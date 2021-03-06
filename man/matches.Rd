\name{matches}
\alias{\%matches\%}
\alias{\%matches\%.character}
\alias{\%matches\%.data.frame}
\alias{\%matches\%.keyed}
\alias{\%matches\%.spec}
\alias{matches}
\title{Test the Correspondence between a Table and a Specification}
\description{ The \code{\%matches\%} operators test whether a data frame matches its 
	corresponding \code{spec}, and vice versa.  The character method treats
	x as the name of a csv-encoded file (na strings `', `.', and NA), 
	and coerces y using \code{as.spec}. The 
	latter in turn should be a single file name for a spec, if character. 
	The method for \code{spec} treats y as the data frame.  The real work
	is done by the \code{keyed} method.

}
\usage{
	\method{\%matches\%}{character}(x, y, ...)
	\method{\%matches\%}{data.frame}(x, y, ...)
	\method{\%matches\%}{keyed}(x, y, ...)
	\method{\%matches\%}{spec}(x, y, ...)
}

\arguments{
  \item{x}{object of dispatch}
  \item{y}{corresponding object}
  \item{\dots}{ignored}
}
\details{
\code{matches} returns TRUE if no exceptions are detected.  It checks the 
following, and issues appropriate messages as necessary.
\itemize{
	\item Column names must match.
	\item Column order must match.
	\item Column type must match; numerics can be typed as integer if 
	they have no trailing decimal places.
	\item Columns of type `datetime' must be coercible using the declared
	format string.  
	\item Each element of a column with an encoded guide element must be one
	of the encoded levels, or NA.
	\item If the guide element ends with some variant of the range specifier
	-- (0, 30) [0, 30] etc. -- then all non-missing values must fall in that range.
	\item Each element of a column must be defined (not NA) wherever the 
	corresponding `required' expression evaluates to TRUE.
}
In short, the following are enforced: names, order, type, format, levels, ranges, and 
presence requirements.
}
\value{scalar logical}
\references{\url{http://metrumrg.googlecode.com}}

\author{ Tim Bergsma }
\seealso{
	\itemize{
		\item \code{\link{as.spec}}
		\item \code{\link{specfile}}
		\item \code{\link{specification}}
		\item \code{\link{codes}}
		\item \code{\link{encode}}
	}
}
\examples{
test <- Theoph
names(test) <- c('SUBJ','WT','DOSE','DATETIME','DV')
test$DATETIME <- as.mDateTime(
  as.mDate('2013-10-17'),
  as.mTime(as.second(round(as.minute(as.second(as.hour(test$DATETIME))))))
)
head(test)
test <- sort(as.keyed(test, c('SUBJ','DATETIME')))
test <- aug(test[!duplicated(test$SUBJ),], AMT=DOSE,DOSE=NULL,EVID=1,SEQ=0,DV=NA) +
        aug(test,DOSE=NULL,EVID=0,SEQ=1)
test <- as.nm(test)
summary(test)
head(test)
for(col in c('TIME','TAFD','TAD')) test[[col]] <- round(test[[col]], 5)
spec <- specification(test)
summary(spec)
spec[1,1] <- paste(' " ',spec[1,1],' " ') # will be stripped by read.spec
spec[1,1]
write.nm(test, 'test.csv')
write.spec(spec,'test.spec')
spec <- read.spec('test.spec')
spec[1,1]
labels(as.spec('test.spec'))
codes(as.spec('test.spec'))
decodes(as.spec('test.spec'))
guidetext(as.spec('test.spec'))

test \%matches\% spec
test \%matches\% 'test.spec'
'test.csv' \%matches\% spec
'test.csv' \%matches\% 'test.spec'
spec \%matches\% test
spec \%matches\% 'test.csv'

as.pdf(as.define(spec),stem = 'test')

unlink('test.csv')
unlink('test.spec')	
unlink('test.pdf')

head(respecify(spec, data=test))
}
\keyword{manip}
